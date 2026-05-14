import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/view/product/product_detail_page_api.dart';
import 'package:coffe_app/view/widgets/products_card.dart';
import 'package:coffe_app/view_model/products_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  final Category category;
  const Products({super.key, required this.category});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late final ProductsViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = ProductsViewModel(service: ProductService());
    _vm.init(widget.category.id);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels >= threshold) {
      _vm.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: _buildAppBar,
            body: Column(
              children: [
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildSearchBar(context),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Consumer<ProductsViewModel>(
                    builder: (context, vm, _) {
                      if (vm.isInitialLoading && vm.items.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (vm.errorMessage != null && vm.items.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              vm.errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }

                      if (vm.items.isEmpty) {
                        return const Center(
                          child: Text("Bu kategoride urun bulunamadi."),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: vm.refresh,
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: vm.items.length + 1,
                          itemBuilder: (context, index) {
                            if (index < vm.items.length) {
                              final p = vm.items[index];
                              return ProductsCard(
                                imagePath: "assets/product/product2/mocha.png",
                                imageUrl: p.imageUrl,
                                title: p.title,
                                category: p.category,
                                price: p.price,
                                rating: 3.8,
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

                            // listenin sonuna loader / bitti bilgisi
                            if (vm.isLoadingMore) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            if (!vm.hasMore) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text(
                                    "Tum urunler yuklendi.",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              );
                            }

                            return const SizedBox.shrink();
                          },
                        ),
                      );
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
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      title: Text(
        widget.category.name,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz, color: Colors.black, size: 28),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  context.read<ProductsViewModel>().onSearchChanged(value),
              decoration: const InputDecoration(
                hintText: "Search in this category",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          const Icon(Icons.search, color: Colors.black, size: 30),
        ],
      ),
    );
  }
}