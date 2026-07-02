import 'dart:ui' as ui;

import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/view/store_location/mixin/store_location_page_mixin.dart';
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

class _StoreLocationPageState extends State<StoreLocationPage>
    with StoreLocationPageMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: storeLocationCubit,
      child: Scaffold(
        backgroundColor: context.appBackground,
        appBar: _buildAppBar,
        body: SafeArea(
          child: BlocConsumer<StoreLocationCubit, StoreLocationState>(
            listener: (context, state) => onStoreLocationStateChanged(state),
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
          onPressed: closePage,
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
                onPressed: reloadStores,
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
                  controller: listScrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: stores.length,
                  separatorBuilder: (_,_) =>
                      const SizedBox(height: AppSpacing.s12),
                  itemBuilder: (context, index) {
                    final store = stores[index];
                    final selected = state.selectedStore?.id == store.id;

                    return StoreLocationCard(
                      key: storeItemKeys.putIfAbsent(store.id, GlobalKey.new),
                      store: store,
                      isSelected: selected,
                      onTap: () => selectStore(store),
                      onDirectionsTap: () => handleDirectionsTap(store),
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
          mapController: mapController,
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
                        onTap: () => selectStore(store),
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
        onTap: () => recenterOnUser(state),
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
