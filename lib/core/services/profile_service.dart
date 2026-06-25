import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_app/model/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const userCollection = 'users';

  String? get _uid => _auth.currentUser?.uid;

  Future<void> createProfile({
    required String name,
    required String email,
  }) async {
    final uid = _uid;
    if (uid == null) throw Exception('Kullanıcı giriş yapmamış');

    try {
      await _firestore.collection(userCollection).doc(uid).set({
        'name': name,
        'email': email,
        'phone': null,
        'address': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      throw Exception(mapFirebaseError(e));
    }
  }

  Future<UserProfile> getProfile() async {
    final uid = _uid;
    if (uid == null) throw Exception('Kullanıcı giriş yapmamış');

    try {
      final doc = await _firestore.collection(userCollection).doc(uid).get();

      if (!doc.exists) {
        final user = _auth.currentUser!;
        final profile = UserProfile(
          uid: uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
        );

        await _firestore.collection(userCollection).doc(uid).set({
          ...profile.toFirestore(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        return profile;
      }

      return UserProfile.fromFirestore(doc.data()!, uid);
    } on FirebaseException catch (e) {
      throw Exception(mapFirebaseError(e));
    }
  }

  Future<UserProfile> updateProfile({
    required String name,
    required String email,
    int? phone,
    String? address,
  }) async {
    final uid = _uid;
    final user = _auth.currentUser;
    if (uid == null || user == null) {
      throw Exception('Kullanıcı giriş yapmamış');
    }

    try {
      if (name != user.displayName) {
        await user.updateDisplayName(name);
      }

      final profile = UserProfile(
        uid: uid,
        name: name,
        email: email,
        phone: phone,
        address: address?.trim().isEmpty == true ? null : address?.trim(),
      );

      await _firestore.collection(userCollection).doc(uid).set(
        {
          ...profile.toFirestore(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      await user.reload();
      return profile;
    } on FirebaseException catch (e) {
      throw Exception(mapFirebaseError(e));
    }
  }

  static String mapFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Firestore izni yok. Firebase Console → Firestore Database → Rules '
            'bölümünde users/{userId} kuralını ekle.';
      case 'unauthenticated':
        return 'Oturum süresi dolmuş. Tekrar giriş yap.';
      case 'unavailable':
        return 'Firestore şu an kullanılamıyor. İnternet bağlantını kontrol et.';
      default:
        return e.message ?? 'Profil verisi alınamadı (${e.code})';
    }
  }
}
