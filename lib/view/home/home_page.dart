import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view/auth/auth_choice_page.dart';
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
        backgroundColor: AppColors.backgroundColor,
        drawer: _buildSideBar,
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeSearchOverlay,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader,
                    const SizedBox(height: 12),
                    _buildSearchbar,
                    const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            _buildCategories(state),
            const SizedBox(height: 12),
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
            padding: const EdgeInsets.only(right: 12),
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
    final categories = _categoriesFromState(state);
    final featuredProducts = _featuredProductsFromState(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Featured Beverages",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            _featuredMoreButton(categories),
          ],
        ),
        const SizedBox(height: 12),
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
            separatorBuilder: (context, index) => const SizedBox(height: 18),
            itemBuilder: (context, index) {
              final product = featuredProducts[index];

              return FeaturedBeverageItem(
                imageUrl: product.imageUrl,
                title: product.title,
                price: "\$${product.price.toStringAsFixed(2)}",
                points: "50 pts",
                rating: "4.5",
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

  Widget _featuredMoreButton(List<Category> categories) {
    return TextButton(
      onPressed: categories.isEmpty
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Products(category: categories.first),
                ),
              );
            },
      child: const Text(
        "More",
        style: TextStyle(
          fontSize: 16,
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategories(HomeState state) {
    final categories = _categoriesFromState(state);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Categories",
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
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
                    style: TextStyle(color: Colors.red),
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
                  padding: const EdgeInsets.only(right: 8),
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

  Widget _buildSearchResultsOverlay(HomeState state) {
    return GestureDetector(
      onTap: () {},
      child: Material(
        elevation: 8,
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 420),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black12),
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
            style: TextStyle(color: Colors.red),
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: state.searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final product = state.searchResults[index];

        return ProductsCard(
          imagePath: "assets/product/product2/mocha.png",
          imageUrl: product.imageUrl,
          title: product.title,
          category: product.category,
          price: product.price,
          rating: 4.5,
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
              const Text(
                "Good Morning",
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 6),
              Text(
                authCubit.currentUserName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
              icon: const Icon(
                Icons.shopping_bag_outlined,
                size: 28,
                color: AppColors.primaryColor,
              ),
            ),
            IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu, size: 30, color: Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _buildSearchbar {
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
              focusNode: _searchFocusNode,
              onChanged: (value) {
                _homeCubit.onSearchChanged(value);
              },
              decoration: const InputDecoration(
                hintText: "Search",
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

  Widget get _buildSideBar {
    return Drawer(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSideBarHeader,
            const SizedBox(height: 12),
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
              const SizedBox(width: 10),
              const Text(
                "Ombe",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close, color: Colors.grey, size: 28),
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
        }),
        _menuItem(Icons.store_outlined, "Store Location", 2, () {
          setState(() => selectedIndex = 2);
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
        const Divider(color: Colors.black12),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text(
            "Log Out",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
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

  Widget _menuItem(
    IconData icon,
    String title,
    int index,
    VoidCallback onTap,
  ) {
    final isSelected = selectedIndex == index;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primaryColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.primaryColor : Colors.grey,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}