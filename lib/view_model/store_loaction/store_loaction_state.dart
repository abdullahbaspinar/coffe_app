import 'package:coffe_app/model/store_location.dart';
import 'package:latlong2/latlong.dart';

abstract class StoreLocationState {
  const StoreLocationState();
}

class StoreLocationInitial extends StoreLocationState {
  const StoreLocationInitial();
}

class StoreLocationLoading extends StoreLocationState {
  const StoreLocationLoading();
}

class StoreLocationLoaded extends StoreLocationState {
  final LatLng userPosition;
  final List<StoreLocation> allStores;
  final StoreLocation? selectedStore;

  const StoreLocationLoaded({
    required this.userPosition,
    required this.allStores,
    this.selectedStore,
  });

  StoreLocationLoaded copyWith({
    LatLng? userPosition,
    List<StoreLocation>? allStores,
    StoreLocation? selectedStore,
    bool clearSelected = false,
  }) {
    return StoreLocationLoaded(
      userPosition: userPosition ?? this.userPosition,
      allStores: allStores ?? this.allStores,
      selectedStore:
          clearSelected ? null : (selectedStore ?? this.selectedStore),
    );
  }
}

class StoreLocationError extends StoreLocationState {
  final String message;

  const StoreLocationError({required this.message});
}