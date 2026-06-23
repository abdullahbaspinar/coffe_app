import 'package:bloc/bloc.dart';
import 'package:coffe_app/core/services/store_location_service.dart';
import 'package:coffe_app/model/store_location.dart';
import 'package:coffe_app/view_model/store_loaction/store_loaction_state.dart';
import 'package:latlong2/latlong.dart';

class StoreLocationCubit extends Cubit<StoreLocationState> {
  final StoreLocationService _service;

  StoreLocationCubit({StoreLocationService? service})
      : _service = service ?? StoreLocationService(),
        super(const StoreLocationInitial());

  Future<void> loadStores() async {
    emit(const StoreLocationLoading());

    try {
      final position = await _service.getCurrentPosition();
      final userLat = position.latitude;
      final userLng = position.longitude;

      final allStores = await _service.fetchStarbucks(
        latitude: userLat,
        longitude: userLng,
        limit: 50,
      );

      emit(
        StoreLocationLoaded(
          userPosition: LatLng(userLat, userLng),
          allStores: allStores,
        ),
      );
    } catch (e) {
      emit(StoreLocationError(message: e.toString()));
    }
  }

  void selectStore(StoreLocation store) {
    final current = state;
    if (current is! StoreLocationLoaded) return;

    emit(current.copyWith(selectedStore: store));
  }

  void clearSelectedStore() {
    final current = state;
    if (current is! StoreLocationLoaded) return;

    emit(current.copyWith(clearSelected: true));
  }
}
