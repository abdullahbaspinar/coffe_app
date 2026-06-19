import 'dart:developer';

import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/view/product/product_detail_page_api.dart';
import 'package:coffe_app/view/widgets/products_card.dart';
import 'package:coffe_app/view_model/products/products_cubit.dart';
import 'package:coffe_app/view_model/products/products_state.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_size.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Products extends StatefulWidget {
  final Category category;
  const Products({super.key, required this.category});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final ProductsCubit _cubit;

  @override
  void initState() {
    super.initState();
    // Yapıyı bozmadan yeni Cubit constructor'ımıza uygun hale getirdik
    _cubit = ProductsCubit(ProductService());
    _cubit.fetchProducts(categoryId: widget.category.id);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      // Fonksiyon adını güncelledik
      _cubit.loadMoreProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Builder(
        builder: (context) {
          return Scaffold(
                        appBar: _buildAppBar,
            body: Column(
              children: [
                const SizedBox(height: AppSpacing.s12),
                Padding(
                  padding: AppSpacing.paddingH20,
                  child: _buildSearchBar(context),
                ),
                const SizedBox(height: AppSpacing.s12),
                Expanded(
                  child: BlocBuilder<ProductsCubit, ProductsState>(
                    builder: (context, state) {
                      
                      // 1. Durum: İlk Yükleme Ekranı (ProductsLoading)
                      if (state is ProductsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // 2. Durum: Hata Ekranı (ProductsError)
                      if (state is ProductsError) {
                        return Center(
                          child: Padding(
                            padding: AppSpacing.padding20,
                            child: Text(
                              state.errorMessage, // state.errorMessage! yerine doğrudan erişim
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.error),
                            ),
                          ),
                        );
                      }

                      // 3. Durum: Başarılı Yükleme Ama Liste Boş
                      if (state is ProductsLoaded && state.items.isEmpty) {
                        return const Center(
                          child: Text("Bu kategoride urun bulunamadi."),
                        );
                      }

                      // 4. Durum: Verilerin Ekrana Basıldığı Başarılı Senaryo (ProductsLoaded)
                      if (state is ProductsLoaded) {
                        return RefreshIndicator(
                          onRefresh: () async =>
                              context.read<ProductsCubit>().fetchProducts(categoryId: widget.category.id),
                          child: ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: state.items.length + 1,
                            itemBuilder: (context, index) {
                              if (index < state.items.length) {
                                final p = state.items[index];
                                return ProductsCard(
                                  imagePath: "assets/product/product2/mocha.png",
                                  imageUrl: p.imageUrl,
                                  title: p.title,
                                  category: p.category,
                                  price: p.price,
                                  rating: p.displayRating,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductDetailPageApi(product: p),
                                      ),
                                    );
                                  },
                                );
                              }

                              // Listenin altına loader / bitti bilgisi ekleme mantığı
                              if (state.isLoadingMore) {
                                return const Padding(
                                  padding: AppSpacing.paddingV20,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (!state.hashMore) {
                                return Padding(
                                  padding: AppSpacing.paddingV20,
                                  child: Center(
                                    child: Text(
                                      "Tum urunler yuklendi.",
                                      style: TextStyle(color: context.appTextMuted),
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                        );
                      }

                      // Fallback: Herhangi bir aksilikte boş kutu dön
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
            elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.only(left: 12),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: context.appTextPrimary),
        ),
      ),
      title: Text(
        widget.category.name,
        style: TextStyle(
          color: context.appTextPrimary,
          fontSize: AppTypography.size22,
          fontWeight: AppTypography.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_horiz, color: context.appTextPrimary, size: 28),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: AppSizes.searchBarHeight,
      padding: AppSpacing.paddingH16,
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: AppRadius.border(AppRadius.size30),
        border: Border.all(color: context.appTextPrimary, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                context.read<ProductsCubit>().searchProducts(query: value);
              },
              decoration: InputDecoration(
                hintText: "Search in this category",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: AppTypography.size16, color: context.appTextMuted),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
                isDense: true,
              contentPadding: EdgeInsets.zero,
              filled: false,
              ),
            ),
          ),
          Icon(Icons.search, color: context.appTextPrimary, size: 30),
        ],
      ),
    );
  }
}