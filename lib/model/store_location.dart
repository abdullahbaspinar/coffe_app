class StoreLocation {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? adress;
  final double? distanceKm;

  const StoreLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.adress,
    this.distanceKm,
  });

  factory StoreLocation.fromPhoton(Map<String, dynamic> feature) {
    final geometry = Map<String, dynamic>.from(feature['geometry'] ?? {});
    final coordinates = geometry['coordinates'] as List?;
    final props = Map<String, dynamic>.from(feature['properties'] ?? {});

    if (coordinates == null || coordinates.length < 2) {
      throw FormatException('Geçersiz konum verisi');
    }

    final street = props['street']?.toString();
    final city = props['city']?.toString();
    final addressParts = [street, city].whereType<String>().where((v) => v.isNotEmpty);

    return StoreLocation(
      id: '${props['osm_type']}/${props['osm_id']}',
      name: props['name']?.toString() ?? 'Starbucks',
      longitude: (coordinates[0] as num).toDouble(),
      latitude: (coordinates[1] as num).toDouble(),
      adress: addressParts.isEmpty ? null : addressParts.join(', '),
    );
  }

  StoreLocation copyWith({double? distanceKm}) {
    return StoreLocation(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
      adress: adress,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}
