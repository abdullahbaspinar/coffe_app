import 'dart:io';
import 'dart:ui' as ui;

import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/core/services/map_directions_service.dart';
import 'package:coffe_app/core/services/store_location_service.dart';
import 'package:coffe_app/model/store_location.dart';
import 'package:coffe_app/view/widgets/store_location_card.dart';
import 'package:coffe_app/view_model/store_loaction/store_loaction_state.dart';
import 'package:coffe_app/view_model/store_loaction/store_location_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class StoreLocationPage extends StatefulWidget {
  const StoreLocationPage({super.key});

  @override
  State<StoreLocationPage> createState() => _StoreLocationPageState();
}

class _StoreLocationPageState extends State<StoreLocationPage> {
  final MapController _mapController = MapController();
  final StoreLocationCubit _cubit =
      StoreLocationCubit(service: StoreLocationService());
  final MapDirectionsService _directionsService = MapDirectionsService();
  final Map<String, GlobalKey> _storeItemKeys = {};
  final ScrollController _listScrollController = ScrollController();

  static const double _listItemExtent = 120;

  @override
  void initState() {
    super.initState();
    _cubit.loadStores();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _recenterOnUser(StoreLocationLoaded state) {
    _mapController.move(state.userPosition, 13);
  }

  void _scrollToStore(StoreLocation store, List<StoreLocation> stores) {
    final index = stores.indexWhere((item) => item.id == store.id);
    if (index < 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !_listScrollController.hasClients) return;

      final position = _listScrollController.position;
      final targetOffset = (index * _listItemExtent - position.viewportDimension * 0.2)
          .clamp(0.0, position.maxScrollExtent);

      await _listScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );

      if (!mounted) return;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final itemContext = _storeItemKeys[store.id]?.currentContext;
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

  Future<void> _openDirections(StoreLocation store, MapApp app) async {
    try {
      await _directionsService.openDirections(store, app);
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

  Future<void> _handleDirectionsTap(StoreLocation store) async {
    if (Platform.isIOS) {
      await _showDirectionsSheet(store);
      return;
    }

    await _openDirections(store, MapApp.googleMaps);
  }

  Future<void> _showDirectionsSheet(StoreLocation store) {
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
              _DirectionsOptionTile(
                icon: Icons.map_outlined,
                title: 'Apple Maps',
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await _openDirections(store, MapApp.appleMaps);
                },
              ),
              const SizedBox(height: AppSpacing.s12),
              _DirectionsOptionTile(
                icon: Icons.map_rounded,
                title: 'Google Maps',
                onTap: () async {
                  Navigator.pop(sheetContext);
                  await _openDirections(store, MapApp.googleMaps);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.appBackground,
        appBar: _buildAppBar,
        body: SafeArea(
          child: BlocConsumer<StoreLocationCubit, StoreLocationState>(
            listener: (context, state) {
              if (state is StoreLocationLoaded && state.selectedStore != null) {
                final store = state.selectedStore!;
                _mapController.move(
                  LatLng(store.latitude, store.longitude),
                  16,
                );
                _scrollToStore(store, state.allStores);
              }
            },
            builder: (context, state) {
              if (state is StoreLocationLoading) {
                return Center(
                  child: CircularProgressIndicator(color: context.appPrimary),
                );
              }

              if (state is StoreLocationError) {
                return _buildErrorState(state.message);
              }

              if (state is StoreLocationLoaded) {
                return _buildLoadedContent(state);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: context.appBackground,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          onPressed: () => AppRouter.pop(),
          icon: Icon(Icons.arrow_back_ios_new, color: context.appTextPrimary),
        ),
      ),
      title: Text(
        'Store Locations',
        style: TextStyle(
          color: context.appTextPrimary,
          fontSize: AppTypography.size22,
          fontWeight: AppTypography.bold,
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: AppSpacing.padding20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 56,
              color: context.appTextMuted,
            ),
            const SizedBox(height: AppSpacing.s16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.appTextPrimary,
                fontSize: AppTypography.size16,
              ),
            ),
            const SizedBox(height: AppSpacing.s20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _cubit.loadStores,
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.appPrimary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.border(AppRadius.size30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tekrar Dene',
                  style: TextStyle(fontWeight: AppTypography.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedContent(StoreLocationLoaded state) {
    final stores = state.allStores;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.s12),
        Padding(
          padding: AppSpacing.paddingH20,
          child: SizedBox(
            height: 280,
            child: Stack(
              children: [
                _buildMap(state),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: _buildRecenterButton(state),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Padding(
          padding: AppSpacing.paddingH20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stores',
                style: TextStyle(
                  color: context.appTextPrimary,
                  fontSize: AppTypography.size18,
                  fontWeight: AppTypography.bold,
                ),
              ),
              Text(
                '${stores.length} found',
                style: TextStyle(
                  color: context.appPrimary,
                  fontSize: AppTypography.size14,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s10),
        Expanded(
          child: stores.isEmpty
              ? Center(
                  child: Text(
                    'Yakında Starbucks bulunamadı',
                    style: TextStyle(color: context.appTextMuted),
                  ),
                )
              : ListView.separated(
                  controller: _listScrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: stores.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.s12),
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    final selected = state.selectedStore?.id == store.id;

                    return StoreLocationCard(
                      key: _storeItemKeys.putIfAbsent(store.id, GlobalKey.new),
                      store: store,
                      isSelected: selected,
                      onTap: () => _cubit.selectStore(store),
                      onDirectionsTap: () => _handleDirectionsTap(store),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMap(StoreLocationLoaded state) {
    return ClipRRect(
      borderRadius: AppRadius.border(AppRadius.size20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: AppRadius.border(AppRadius.size20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: state.userPosition,
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.coffe_app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: state.userPosition,
                  width: 48,
                  height: 48,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: context.appPrimary, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.my_location_rounded,
                      color: context.appPrimary,
                      size: 22,
                    ),
                  ),
                ),
                ...state.allStores.map(
                  (store) {
                    final isSelected = state.selectedStore?.id == store.id;

                    return Marker(
                      point: LatLng(store.latitude, store.longitude),
                      width: 44,
                      height: 52,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () => _cubit.selectStore(store),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? context.appPrimary
                                    : AppColors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.appPrimary,
                                  width: 2,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.shadow,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.coffee_rounded,
                                size: 18,
                                color: isSelected
                                    ? AppColors.white
                                    : context.appPrimary,
                              ),
                            ),
                            CustomPaint(
                              size: const Size(12, 8),
                              painter: _PinTailPainter(
                                color: isSelected
                                    ? context.appPrimary
                                    : context.appPrimary.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecenterButton(StoreLocationLoaded state) {
    return Material(
      color: AppColors.white,
      elevation: 4,
      shadowColor: AppColors.shadow,
      borderRadius: AppRadius.border(AppRadius.size14),
      child: InkWell(
        onTap: () => _recenterOnUser(state),
        borderRadius: AppRadius.border(AppRadius.size14),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            Icons.near_me_rounded,
            color: context.appPrimary,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _DirectionsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DirectionsOptionTile({
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

class _PinTailPainter extends CustomPainter {
  final Color color;

  _PinTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PinTailPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
