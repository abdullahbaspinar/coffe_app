import 'dart:async';

import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/core/services/product_service.dart';
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
import 'package:coffe_app/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class FeaturedBeverages {
  String imagePath;
  String title;
  String price;
  String points;
  String ratings;

  FeaturedBeverages({
    required this.imagePath,
    required this.title,
    required this.price,
    required this.points,
    required this.ratings,
  });
}

class _HomePageState extends State<HomePage> {
  final ProductService _productService = ProductService();
  List<Category> _categories = [];
  bool _categoriesLoading = true;
  String? _categoriesError;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _categoriesLoading = true;
      _categoriesError = null;
    });

    try {
      final categories = await _productService.fetchCategories();
      setState(() {
        _categories = categories.take(8).toList();
      });
    } catch (e) {
      setState(() {
        _categoriesError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _categoriesLoading = false;
        });
      }
    }
  }

  int selectedIndex = 0;
  AuthViewModel get authViewModel => context.watch<AuthViewModel>();

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

  final List<FeaturedBeverages> featuredBeveerages = [
    FeaturedBeverages(
      imagePath: "assets/product/product2/tea.png",
      title: "Hot Creamy Cappucccino Latte Ombe",
      price: "\$12.6",
      points: "50",
      ratings: "3.8",
    ),
    FeaturedBeverages(
      imagePath: "assets/product/product2/mocha.png",
      title: "Creamy Mocha Ombe Coffe",
      price: "\$12.6",
      points: "50",
      ratings: "3.8",
    ),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<Product> _searchResults = [];
  bool _searchLoading = false;
  String? _searchError;
  String _searchQuery = "";
  Timer? _searchDebounce;

  void _onSearchChanged(String value) {
    final trimmed = value.trim();

    setState(() {
      _searchQuery = value;
      _searchLoading = trimmed.isNotEmpty;

      if (trimmed.isEmpty) {
        _searchResults = [];
        _searchError = null;
      }
    });

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 200), () {
      _searchProducts(value);
    });
  }

  Future<void> _searchProducts(String query) async {
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      setState(() {
        _searchResults = [];
        _searchError = null;
        _searchLoading = false;
      });
      return;
    }

    setState(() {
      _searchLoading = true;
      _searchError = null;
    });

    try {
      final results = await _productService.searchAllProducts(
        query: trimmed,
        offset: 0,
        limit: 20,
      );

      if (!mounted) return;
      if (trimmed != _searchQuery.trim()) return;

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _searchError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _searchLoading = false;
        });
      }
    }
  }

  void _closeSearchOverlay() {
    if (_searchQuery.trim().isEmpty && _searchResults.isEmpty) return;

    _searchDebounce?.cancel();
    _searchFocusNode.unfocus();
    _searchController.clear();

    setState(() {
      _searchQuery = "";
      _searchResults = [];
      _searchError = null;
      _searchLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: _buildHomeContent,
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildHomeContent {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader,
        SizedBox(height: 12),
        _buildSearchbar,
        SizedBox(height: 12),
        _buildMainContent,
      ],
    );
  }

  Widget get _buildMainContent {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBody,
            SizedBox(height: 12),
            _buildCategories,
            SizedBox(height: 12),
            _buildFeaturedBeverages,
          ],
        ),
        if (_searchQuery.trim().isNotEmpty)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildSearchResultsOverlay,
          ),
      ],
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
              _goodMorningText,
              const SizedBox(height: 6),
              _usernameText,
            ],
          ),
        ),

        Row(children: [_ordersIcon, _sideBarIcon]),
      ],
    );
  }

  Widget get _goodMorningText {
    return const Text(
      "Good Morning",
      style: TextStyle(fontSize: 14, color: Colors.black),
    );
  }

  Widget get _usernameText {
    return Text(
      authViewModel.currentUserName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget get _ordersIcon {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Orders()),
        );
      },
      icon: const Icon(
        Icons.shopping_bag_outlined,
        size: 28,
        color: AppColors.primaryColor,
      ),
    );
  }

  Widget get _sideBarIcon {
    return IconButton(
      onPressed: () {
        _scaffoldKey.currentState?.openDrawer();
      },
      icon: const Icon(Icons.menu, size: 30, color: Colors.black),
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
            children: [_sideBarLogo, const SizedBox(width: 10), _sideBarText],
          ),
          _sidebarCloseIcon,
        ],
      ),
    );
  }

  Widget get _sideBarLogo {
    return Image.asset(
      "assets/images/logo.png",
      width: 50,
      height: 50,
      fit: BoxFit.contain,
    );
  }

  Widget get _sideBarText {
    return const Text(
      "Ombe",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget get _sidebarCloseIcon {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(Icons.close, color: Colors.grey, size: 28),
    );
  }

  Widget get _buildMenuItems {
    return Column(
      children: [
        _menuItemHome,
        _menuItemOrders,
        _menuItemStoreLocation,
        _menuItemProfile,
        const Divider(color: Colors.black12),
        _menuItemLogOut,
      ],
    );
  }

  Widget get _menuItemHome {
    return ListTile(
      leading: Icon(
        Icons.home_outlined,
        color: selectedIndex == 0 ? AppColors.primaryColor : Colors.grey,
      ),
      title: Text(
        "Home",
        style: TextStyle(
          color: selectedIndex == 0 ? AppColors.primaryColor : Colors.grey,
          fontWeight: selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() {
          selectedIndex = 0;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget get _menuItemOrders {
    return ListTile(
      leading: Icon(
        Icons.shopping_bag_outlined,
        color: selectedIndex == 1 ? AppColors.primaryColor : Colors.grey,
      ),
      title: Text(
        "My Order",
        style: TextStyle(
          color: selectedIndex == 1 ? AppColors.primaryColor : Colors.grey,
          fontWeight: selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() {
          selectedIndex = 1;
        });
      },
    );
  }

  Widget get _menuItemStoreLocation {
    return ListTile(
      leading: Icon(
        Icons.store_outlined,
        color: selectedIndex == 2 ? AppColors.primaryColor : Colors.grey,
      ),
      title: Text(
        "Store Location",
        style: TextStyle(
          color: selectedIndex == 2 ? AppColors.primaryColor : Colors.grey,
          fontWeight: selectedIndex == 2 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() {
          selectedIndex = 2;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget get _menuItemProfile {
    return ListTile(
      leading: Icon(
        Icons.person_outline,
        color: selectedIndex == 3 ? AppColors.primaryColor : Colors.grey,
      ),
      title: Text(
        "Profile",
        style: TextStyle(
          color: selectedIndex == 3 ? AppColors.primaryColor : Colors.grey,
          fontWeight: selectedIndex == 3 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () async {
        setState(() {
          selectedIndex = 3;
        });

        Navigator.pop(context);

        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );

        setState(() {
          selectedIndex = 0;
        });
      },
    );
  }

  Widget get _menuItemLogOut {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        "Log Out",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
      ),
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthChoicePage()),
          (route) => false,
        );
      },
    );
  }

  Widget get _buildSearchbar {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 58,
        padding: EdgeInsets.symmetric(horizontal: 16),
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
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: "Search",
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            Icon(Icons.search, color: Colors.black, size: 30),
          ],
        ),
      ),
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

  Widget get _buildSearchResultsOverlay {
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
          child: _buildSearchResultsContent,
        ),
      ),
    );
  }

  Widget get _buildSearchResultsContent {
    if (_searchLoading) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_searchError != null) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(
            "Arama başarısız",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: Text("Sonuç bulunamadı")),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      itemCount: _searchResults.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final product = _searchResults[index];

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

  Widget get _buildCategories {
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

        if (_categoriesLoading)
          const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_categoriesError != null)
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
                  onPressed: _loadCategories,
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
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final item = _categories[index];
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

  Widget get _buildFeaturedBeverages {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_featuredBeveragesText, _featuredBeverageasTextButton],
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: featuredBeveerages.length,
          separatorBuilder: (context, index) => const SizedBox(height: 18),
          itemBuilder: (context, index) {
            final item = featuredBeveerages[index];
            return FeaturedBeverageItem(
              imagePath: item.imagePath,
              title: item.title,
              price: item.price,
              points: "${item.points} pts ",
              rating: item.ratings,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductDetail()),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget get _featuredBeveragesText {
    return const Text(
      "Featured Beverages",
      style: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget get _featuredBeverageasTextButton {
    return TextButton(
      onPressed: _categories.isEmpty
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Products(category: _categories.first),
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
}
