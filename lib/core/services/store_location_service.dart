import 'dart:convert';

import 'package:coffe_app/model/store_location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class StoreLocationService {
  static const _mapUrl = 'https://photon.komoot.io/api/';

  Future<Position> getCurrentPosition() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Konum servisi kapalı');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Konum izni verilmedi');
    }

    return Geolocator.getCurrentPosition();
  }

  Future<List<StoreLocation>> fetchStarbucks({
    required double latitude,
    required double longitude,
    int limit = 50,
  }) async {
    final uri = Uri.parse(_mapUrl).replace(
      queryParameters: {
        'q': 'starbucks',
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'limit': '$limit',
      },
    );

    final response = await http
        .get(
          uri,
          headers: const {'User-Agent': 'coffe_app/1.0'},
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception(
        'Şubeler alınamadı (${response.statusCode}). İnternet bağlantını kontrol et.',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final features = (data['features'] as List?) ?? [];

    final stores = <StoreLocation>[];
    final seenIds = <String>{};

    for (final feature in features) {
      final map = Map<String, dynamic>.from(feature as Map);
      final name =
          map['properties']?['name']?.toString().toLowerCase() ?? '';

      if (!name.contains('starbucks')) continue;

      try {
        final store = StoreLocation.fromPhoton(map);
        if (seenIds.add(store.id)) {
          stores.add(store);
        }
      } catch (_) {
        continue;
      }
    }

    stores.sort((a, b) {
      final da = _distanceKm(latitude, longitude, a.latitude, a.longitude);
      final db = _distanceKm(latitude, longitude, b.latitude, b.longitude);
      return da.compareTo(db);
    });

    return stores
        .map(
          (store) => store.copyWith(
            distanceKm: _distanceKm(
              latitude,
              longitude,
              store.latitude,
              store.longitude,
            ),
          ),
        )
        .toList();
  }

  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    const distance = Distance();
    return distance.as(
      LengthUnit.Kilometer,
      LatLng(lat1, lon1),
      LatLng(lat2, lon2),
    );
  }
}
