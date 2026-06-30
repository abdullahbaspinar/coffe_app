import 'dart:io';

import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/services/map_directions_service.dart';
import 'package:coffe_app/core/services/store_location_service.dart';
import 'package:coffe_app/model/store_location.dart';
import 'package:coffe_app/view/store_location/store_loaction.dart';
import 'package:coffe_app/view_model/store_loaction/store_loaction_state.dart';
import 'package:coffe_app/view_model/store_loaction/store_location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

mixin StoreLocationPageMixin on State<StoreLocationPage> {
  final MapController mapController = MapController();
  final StoreLocationCubit storeLocationCubit =
      StoreLocationCubit(service: StoreLocationService());
  final MapDirectionsService directionsService = MapDirectionsService();
  final Map<String, GlobalKey> storeItemKeys = {};
  final ScrollController listScrollController = ScrollController();

  static const double listItemExtent = 120;

  @override
  void initState() {
    super.initState();
    storeLocationCubit.loadStores();
  }

  @override
  void dispose() {
    listScrollController.dispose();
    storeLocationCubit.close();
    super.dispose();
  }

  void onStoreLocationStateChanged(StoreLocationState state) {
    if (state is StoreLocationLoaded && state.selectedStore != null) {
      final store = state.selectedStore!;
      mapController.move(
        LatLng(store.latitude, store.longitude),
        16,
      );
      scrollToStore(store, state.allStores);
    }
  }

  void recenterOnUser(StoreLocationLoaded state) {
    mapController.move(state.userPosition, 13);
  }

  void scrollToStore(StoreLocation store, List<StoreLocation> stores) {
    final index = stores.indexWhere((item) => item.id == store.id);
    if (index < 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !listScrollController.hasClients) return;

      final position = listScrollController.position;
      final targetOffset = (index * listItemExtent - position.viewportDimension * 0.2)
          .clamp(0.0, position.maxScrollExtent);

      await listScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );

      if (!mounted) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final itemContext = storeItemKeys[store.id]?.currentContext;
        if (itemContext == null) return;

        Scrollable.ensureVisible(
          itemContext,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      });
    });
  }

  Future<void> openDirections(StoreLocation store, MapApp app) async {
    try {
      await directionsService.openDirections(store, app);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e is Exception
                ? e.toString().replaceFirst('Exception: ', '')
                : 'Harita uygulaması açılamadı',
          ),
        ),
      );
    }
  }

  Future<void> handleDirectionsTap(StoreLocation store) async {
    if (Platform.isIOS) {
      await showDirectionsSheet(store);
      return;
    }

    await openDirections(store, MapApp.googleMaps);
  }

  Future<void> showDirectionsSheet(StoreLocation store) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.appBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: AppSpacing.padding20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Yol tarifi al',
                style: TextStyle(
                  color: context.appTextPrimary,
                  fontSize: AppTypography.size18,
                  fontWeight: AppTypography.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Text(
                store.name,
                style: TextStyle(
                  color: context.appTextMuted,
                  fontSize: AppTypography.size14,
                ),
              ),
              const SizedBox(height: AppSpacing.s20),
              StoreDirectionsOptionTile(
                icon: Icons.map_outlined,
                title: 'Apple Maps',
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await openDirections(store, MapApp.appleMaps);
                },
              ),
              const SizedBox(height: AppSpacing.s12),
              StoreDirectionsOptionTile(
                icon: Icons.map_rounded,
                title: 'Google Maps',
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await openDirections(store, MapApp.googleMaps);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void selectStore(StoreLocation store) {
    storeLocationCubit.selectStore(store);
  }

  void reloadStores() {
    storeLocationCubit.loadStores();
  }

  void closePage() {
    AppRouter.pop();
  }
}

class StoreDirectionsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const StoreDirectionsOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.border(AppRadius.size16),
        child: Ink(
          padding: AppSpacing.padding16,
          decoration: BoxDecoration(
            color: context.appBackground,
            borderRadius: AppRadius.border(AppRadius.size16),
            border: Border.all(color: context.appBorder.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.appPrimaryTint,
                  borderRadius: AppRadius.border(AppRadius.size12),
                ),
                child: Icon(icon, color: context.appPrimary),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: context.appTextPrimary,
                    fontSize: AppTypography.size16,
                    fontWeight: AppTypography.semiBold,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: context.appTextMuted),
            ],
          ),
        ),
      ),
    );
  }
}
