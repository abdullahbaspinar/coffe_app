import 'dart:io';

import 'package:coffe_app/model/store_location.dart';
import 'package:url_launcher/url_launcher.dart';

enum MapApp { appleMaps, googleMaps }

class MapDirectionsService {
  Future<void> openAppleMaps(StoreLocation store) async {
    final lat = store.latitude;
    final lng = store.longitude;

    final candidates = <Uri>[
      Uri.parse('http://maps.apple.com/?daddr=$lat,$lng&dirflg=d'),
      Uri.parse('https://maps.apple.com/?daddr=$lat,$lng&dirflg=d'),
      Uri.parse('maps://?daddr=$lat,$lng&dirflg=d'),
    ];

    await _launchFirstAvailable(candidates, 'Apple Maps açılamadı');
  }

  Future<void> openGoogleMaps(StoreLocation store) async {
    final lat = store.latitude;
    final lng = store.longitude;
    final destination = '$lat,$lng';

    final candidates = <Uri>[
      if (Platform.isAndroid) ...[
        Uri.parse('google.navigation:q=$destination'),
        Uri.parse('geo:0,0?q=$destination(${Uri.encodeComponent(store.name)})'),
      ],
      if (Platform.isIOS)
        Uri.parse(
          'comgooglemaps://?daddr=$destination&directionsmode=driving',
        ),
      Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$destination&travelmode=driving',
      ),
    ];

    await _launchFirstAvailable(candidates, 'Google Maps açılamadı');
  }

  Future<void> openDirections(StoreLocation store, MapApp app) {
    switch (app) {
      case MapApp.appleMaps:
        return openAppleMaps(store);
      case MapApp.googleMaps:
        return openGoogleMaps(store);
    }
  }

  Future<void> _launchFirstAvailable(
    List<Uri> candidates,
    String errorMessage,
  ) async {
    for (final uri in candidates) {
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) return;
      } catch (_) {
        continue;
      }
    }

    throw Exception(errorMessage);
  }
}
