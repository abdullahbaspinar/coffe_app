import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/router/app_routes.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/model/home-product.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view/home/home_page.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:coffe_app/view_model/home/home_cubit.dart';
import 'package:coffe_app/view_model/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin HomePageMixin on State<HomePage> {
  int selectedIndex = 0;
  AuthCubit get authCubit => context.watch<AuthCubit>();

  late final HomeCubit homeCubit;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  final List<HomeProduct> products = [
    HomeProduct(
      imagePath: 'assets/product/product1.png',
      title: 'Ice Latte',
      price: '\$5.8',
      oldPrice: '\$9.9',
    ),
    HomeProduct(
      imagePath: 'assets/product/product2.png',
      title: 'Caramel Latte',
      price: '\$6.2',
      oldPrice: '\$8.5',
    ),
    HomeProduct(
      imagePath: 'assets/product/product1.png',
      title: 'Mocha Frappe',
      price: '\$7.1',
      oldPrice: '\$10.0',
    ),
    HomeProduct(
      imagePath: 'assets/product/product2.png',
      title: 'Mocha Frappe',
      price: '\$7.1',
      oldPrice: '\$10.0',
    ),
  ];

  @override
  void initState() {
    super.initState();
    homeCubit = HomeCubit()..loadHomeData();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    homeCubit.close();
    super.dispose();
  }

  void closeSearchOverlay() {
    final state = homeCubit.state;
    if (state.searchQuery.trim().isEmpty && state.searchResults.isEmpty) {
      return;
    }

    searchFocusNode.unfocus();
    searchController.clear();
    homeCubit.clearSearch();
  }

  void onSearchChanged(String value) {
    homeCubit.onSearchChanged(value);
  }

  void reloadHomeData() {
    homeCubit.loadHomeData();
  }

  List<Category> categoriesFromState(HomeState state) {
    return state.categories;
  }

  List<Product> featuredProductsFromState(HomeState state) {
    return state.featuredProducts;
  }

  bool isSearchLoading(HomeState state) {
    return state is HomeLoaded && state.isSearchLoading;
  }

  String? searchError(HomeState state) {
    if (state is HomeLoaded) return state.searchError;
    return null;
  }

  Category? targetCategoryForFeatured(
    List<Category> categories,
    List<Product> featuredProducts,
  ) {
    if (featuredProducts.isEmpty) return null;

    final featuredCategoryIds =
        featuredProducts.map((product) => product.categoryId).toSet();

    final targetCategoryId = featuredCategoryIds.length == 1
        ? featuredCategoryIds.first
        : featuredProducts.first.categoryId;

    for (final category in categories) {
      if (category.id == targetCategoryId) {
        return category;
      }
    }

    return null;
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    Navigator.pop(context);
  }

  void openProductDetailLocal() {
    AppRouter.navigatePushNamed(AppRoutes.productDetailLocal.path);
  }

  void openProductDetail(Product product) {
    AppRouter.openProductDetail(product);
  }

  void openProductsByCategory(Category category) {
    AppRouter.openProductsByCategory(category);
  }

  void openAllCategories() {
    AppRouter.navigatePushNamed(AppRoutes.categories.path);
  }

  void openOrders() {
    AppRouter.navigatePushNamed(AppRoutes.orders.path);
  }

  void openStoreLocation() {
    AppRouter.navigatePushNamed(AppRoutes.storeLocation.path);
  }

  Future<void> openProfile() async {
    await AppRouter.navigatePushNamed(AppRoutes.profile.path);
  }

  void onDrawerHomeTap() {
    setState(() => selectedIndex = 0);
    closeDrawer();
  }

  void onDrawerOrderTap() {
    setState(() => selectedIndex = 1);
    openOrders();
    setState(() => selectedIndex = 0);
  }

  void onDrawerShopTap() {
    setState(() => selectedIndex = 0);
    openStoreLocation();
  }

  Future<void> onDrawerProfileTap() async {
    setState(() => selectedIndex = 3);
    closeDrawer();
    await openProfile();
    if (!mounted) return;
    setState(() => selectedIndex = 0);
  }

  Future<void> onLogoutTap() async {
    await context.read<AuthCubit>().signOut();
    if (!mounted) return;
    AppRouter.goNamed(AppRoutes.auth.path);
  }
}
