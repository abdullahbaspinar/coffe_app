import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_app/model/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  CartService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  static const userCollection = 'users';
  static const cartCollection = 'cart';

  bool get isLoggedIn => _auth.currentUser != null;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _cartRef(String uid) {
    return _firestore
        .collection(userCollection)
        .doc(uid)
        .collection(cartCollection);
  }

  Future<List<CartItem>> fetchCartItems() async {
    final uid = _uid;
    if (uid == null) {
      throw Exception('Kullanıcı giriş yapmamış');
    }

    try {
      final snapshot = await _cartRef(uid).get();
      return snapshot.docs.map(_cartItemFromDoc).toList();
    } on FirebaseException catch (e) {
      throw Exception(mapFirebaseError(e));
    }
  }

  Future<void> saveCartItems(List<CartItem> items) async {
    final uid = _uid;
    if (uid == null) {
      throw Exception('Kullanıcı giriş yapmamış');
    }

    try {
      final ref = _cartRef(uid);
      final snapshot = await ref.get();
      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      for (final item in items) {
        batch.set(
          ref.doc('${item.product.id}'),
          {
            ...item.toJson(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception(mapFirebaseError(e));
    }
  }

  Future<void> clearCart() async {
    await saveCartItems([]);
  }

  CartItem _cartItemFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return CartItem.fromMap(Map<String, dynamic>.from(data));
  }


  // firbase hat kodları
  static String mapFirebaseError(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Sepet için Firestore izni yok. Firebase Console → Rules '
            'bölümünde users/{userId}/cart kuralını ekle.';
      case 'unauthenticated':
        return 'Oturum süresi dolmuş. Tekrar giriş yap.';
      case 'unavailable':
        return 'Firestore şu an kullanılamıyor. İnternet bağlantını kontrol et.';
      default:
        return e.message ?? 'Sepet verisi alınamadı (${e.code})';
    }
  }
}
