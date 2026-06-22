import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view/auth/auth_choice_page.dart';
import 'package:coffe_app/view/categories/all_categories.dart';
import 'package:coffe_app/view/orders/orders.dart';
import 'package:coffe_app/view/product/product_detail_page.dart';
import 'package:coffe_app/view/product/product_detail_page_api.dart';
import 'package:coffe_app/view/product/products.dart';
import 'package:coffe_app/view/profile/profile_page.dart';
import 'package:coffe_app/view/widgets/categories_card.dart';
import 'package:coffe_app/view/widgets/featured_beverages.dart';
import 'package:coffe_app/view/widgets/product_card.dart';
import 'package:coffe_app/view/widgets/products_card.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:coffe_app/view_model/home/home_cubit.dart';
import 'package:coffe_app/view_model/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_size.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class HomeProduct {
  final String imagePath;
  final String title;
  final String price;
  final String oldPrice;

  HomeProduct({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.oldPrice,
  });
}

class _HomePageState extends State<HomePage> {
  late final HomeCubit _homeCubit;

  int selectedIndex = 0;
  AuthCubit get authCubit => context.watch<AuthCubit>();

  final List<HomeProduct> products = [
    HomeProduct(
      imagePath: "assets/product/product1.png",
      title: "Ice Latte",
      price: "\$5.8",
      oldPrice: "\$9.9",
    ),
    HomeProduct(
      imagePath: "assets/product/product2.png",
      title: "Caramel Latte",
      price: "\$6.2",
      oldPrice: "\$8.5",
    ),
    HomeProduct(
      imagePath: "assets/product/product1.png",
      title: "Mocha Frappe",
      price: "\$7.1",
      oldPrice: "\$10.0",
    ),
    HomeProduct(
      imagePath: "assets/product/product2.png",
      title: "Mocha Frappe",
      price: "\$7.1",
      oldPrice: "\$10.0",
    ),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _homeCubit = HomeCubit()..loadHomeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _homeCubit.close();
    super.dispose();
  }

  void _closeSearchOverlay() {
    final state = _homeCubit.state;
    if (state.searchQuery.trim().isEmpty && state.searchResults.isEmpty) {
      return;
    }

    _searchFocusNode.unfocus();
    _searchController.clear();
    _homeCubit.clearSearch();
  }

  List<Category> _categoriesFromState(HomeState state) {
    if (state is HomeLoaded) return state.categories;
    return state.categories;
  }

  List<Product> _featuredProductsFromState(HomeState state) {
    return state.featuredProducts;
  }

  bool _isSearchLoading(HomeState state) {
    return state is HomeLoaded && state.isSearchLoading;
  }

  String? _searchError(HomeState state) {
    if (state is HomeLoaded) return state.searchError;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeCubit,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _buildSideBar,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeSearchOverlay,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: AppSpacing.padding20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader,
                    const SizedBox(height: AppSpacing.s12),
                    _buildSearchbar,
                    const SizedBox(height: AppSpacing.s12),
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        return _buildMainContent(state);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(HomeState state) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBody,
            const SizedBox(height: AppSpacing.s12),
            _buildCategories(state),
            const SizedBox(height: AppSpacing.s12),
            _buildFeaturedBeverages(state),
          ],
        ),
        if (state.searchQuery.trim().isNotEmpty)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildSearchResultsOverlay(state),
          ),
      ],
    );
  }

  Widget get _buildBody {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: ProductCard(
              imagePath: product.imagePath,
              title: product.title,
              price: product.price,
              oldPrice: product.oldPrice,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetail()),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedBeverages(HomeState state) {
    final categories = _categoriesFromState(state).take(8).toList();
    final featuredProducts = _featuredProductsFromState(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Featured Beverages",
              style: TextStyle(
                color: context.appTextPrimary,
                fontSize: AppTypography.size20,
                fontWeight: AppTypography.bold,
              ),
            ),
            _featuredMoreButton(categories, featuredProducts),
          ],
        ),
        const SizedBox(height: AppSpacing.s12),
        if (state is HomeLoading || state is HomeInitial)
          const SizedBox(
            height: 120,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (featuredProducts.isEmpty)
          const SizedBox(
            height: 120,
            child: Center(child: Text("Öne çıkan ürün bulunamadı")),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featuredProducts.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.s18),
            itemBuilder: (context, index) {
              final product = featuredProducts[index];

              return FeaturedBeverageItem(
                imageUrl: product.imageUrl,
                title: product.title,
                price: "\$${product.price.toStringAsFixed(2)}",
                points: "50 pts",
                rating: product.displayRating.toStringAsFixed(1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPageApi(product: product),
                    ),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _featuredMoreButton(
    List<Category> categories,
    List<Product> featuredProducts,
  ) {
    final featuredCategoryIds = featuredProducts
        .map((p) => p.categoryId)
        .toSet();

    if (featuredCategoryIds.isEmpty) {
      return TextButton(onPressed: null, child: Text("More"));
    }

    final targetCategoryId = featuredCategoryIds.length == 1
        ? featuredCategoryIds.first
        : featuredProducts.first.categoryId;

    final targetCategory = categories.cast<Category?>().firstWhere(
      (c) => c!.id == targetCategoryId,
      orElse: () => null,
    );

    return TextButton(
      onPressed: targetCategory == null
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Products(category: targetCategory),
                ),
              );
            },
      child: Text("More",style: TextStyle(fontWeight: AppTypography.bold),),
    );
  }

  Widget _buildCategories(HomeState state) {
    final categories = _categoriesFromState(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Categories",
              style: TextStyle(
                fontSize: AppTypography.size16,
                color: context.appTextPrimary,
                fontWeight: AppTypography.bold,
              ),
            ),
            _allCategoriesButton(),
          ],
        ),

        const SizedBox(height: AppSpacing.s12),
        if (state is HomeLoading || state is HomeInitial)
          const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state is HomeError)
          SizedBox(
            height: 60,
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Kategoriler yüklenemedi.",
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _homeCubit.loadHomeData();
                  },
                  child: const Text("Tekrar Dene"),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final item = categories[index];
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: CategoriesCard(
                    title: item.name,
                    imageUrl: item.image,
                    menuCount: null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Products(category: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _allCategoriesButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AllCategories()),
        );
      },
      child: Text("All Categories",style: TextStyle(fontWeight: AppTypography.bold),),
    );
  }

  Widget _buildSearchResultsOverlay(HomeState state) {
    return GestureDetector(
      onTap: () {},
      child: Material(
        elevation: 8,
        color: context.appBackground,
        borderRadius: AppRadius.border(AppRadius.size18),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 420),
          decoration: BoxDecoration(
            color: context.appBackground,
            borderRadius: AppRadius.border(AppRadius.size18),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: _buildSearchResultsContent(state),
        ),
      ),
    );
  }

  Widget _buildSearchResultsContent(HomeState state) {
    if (_isSearchLoading(state)) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_searchError(state) != null) {
      return const SizedBox(
        height: 120,
        child: Center(
          child: Text(
            "Arama başarısız",
            style: TextStyle(color: AppColors.error),
          ),
        ),
      );
    }

    if (state.searchResults.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text("Sonuç bulunamadı")),
      );
    }

    return ListView.separated(
      padding: AppSpacing.paddingV12,
      shrinkWrap: true,
      itemCount: state.searchResults.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.s8),
      itemBuilder: (context, index) {
        final product = state.searchResults[index];

        return ProductsCard(
          imagePath: "assets/product/product2/mocha.png",
          imageUrl: product.imageUrl,
          title: product.title,
          category: product.category,
          price: product.price,
          rating: product.displayRating,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPageApi(product: product),
              ),
            );
          },
        );
      },
    );
  }

  Widget get _buildHeader {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning",
                style: TextStyle(
                  fontSize: AppTypography.size14,
                  color: context.appTextPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.s6),
              Text(
                authCubit.currentUserName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppTypography.size24,
                  fontWeight: AppTypography.bold,
                  color: context.appTextPrimary,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Orders()),
                );
              },
              icon: Icon(
                Icons.shopping_bag_outlined,
                size: 28,
                color: context.appPrimary,
              ),
            ),
            IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: Icon(Icons.menu, size: 30, color: context.appTextPrimary),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _buildSearchbar {
    return Container(
      height: AppSizes.searchBarHeight,
      padding: AppSpacing.paddingH16,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: AppRadius.border(AppRadius.size30),
        border: Border.all(
          color: context.appTextPrimary, // hep beyaz
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: (value) {
                _homeCubit.onSearchChanged(value);
              },
              style: TextStyle(
                color: context.appTextPrimary,
                fontSize: AppTypography.size16,
              ),
              cursorColor: context.appTextPrimary,
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  fontSize: AppTypography.size16,
                  color: context.appTextMuted,
                ),

                border: InputBorder.none,
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

  Widget get _buildSideBar {
    return Drawer(
      backgroundColor: context.appBackground,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSideBarHeader,
            const SizedBox(height: AppSpacing.s12),
            _buildMenuItems,
          ],
        ),
      ),
    );
  }

  Widget get _buildSideBarHeader {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 12,
        bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/logo.png",
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              SizedBox(width: AppSpacing.s10),
              Text(
                "Ombe",
                style: TextStyle(
                  fontSize: AppTypography.size24,
                  fontWeight: AppTypography.bold,
                  color: context.appTextPrimary,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close, color: context.appTextMuted, size: 28),
          ),
        ],
      ),
    );
  }

  Widget get _buildMenuItems {
    return Column(
      children: [
        _menuItem(Icons.home_outlined, "Home", 0, () {
          setState(() => selectedIndex = 0);
          Navigator.pop(context);
        }),
        _menuItem(Icons.shopping_bag_outlined, "My Order", 1, () {
          setState(() => selectedIndex = 1);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Orders()),
          );
          setState(() => selectedIndex = 0);
        }),
        _menuItem(Icons.store_outlined, "Store Location", 2, () {
          setState(() => selectedIndex = 0);
          Navigator.pop(context);
        }),
        _menuItem(Icons.person_outline, "Profile", 3, () async {
          setState(() => selectedIndex = 3);
          Navigator.pop(context);
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfilePage()),
          );
          setState(() => selectedIndex = 0);
        }),
        const Divider(color: AppColors.borderLight),
        ListTile(
          leading: const Icon(Icons.logout, color: AppColors.error),
          title: const Text(
            "Log Out",
            style: TextStyle(
              color: AppColors.error,
              fontWeight: AppTypography.semiBold,
            ),
          ),
          onTap: () async {
            await context.read<AuthCubit>().signOut();
            if (!context.mounted) return;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const AuthChoicePage()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title, int index, VoidCallback onTap) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? context.appPrimary : AppColors.textMuted,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? context.appPrimary : AppColors.textMuted,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}
