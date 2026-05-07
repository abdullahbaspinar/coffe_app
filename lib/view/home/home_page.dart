import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/core/services/product_service.dart';
import 'package:coffe_app/view/auth/auth_choice_page.dart';
import 'package:coffe_app/view/orders/orders.dart';
import 'package:coffe_app/view/product/product_detail_page.dart';
import 'package:coffe_app/view/product/products.dart';
import 'package:coffe_app/view/profile/profile_page.dart';
import 'package:coffe_app/view/widgets/categories_card.dart';
import 'package:coffe_app/view/widgets/featured_beverages.dart';
import 'package:coffe_app/view/widgets/product_card.dart';
import 'package:coffe_app/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Product {
  final String imagePath;
  final String title;
  final String price;
  final String oldPrice;

  Product({
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

  final List<Product> products = [
    Product(
      imagePath: "assets/product/product1.png",
      title: "Ice Latte",
      price: "\$5.8",
      oldPrice: "\$9.9",
    ),
    Product(
      imagePath: "assets/product/product2.png",
      title: "Caramel Latte",
      price: "\$6.2",
      oldPrice: "\$8.5",
    ),
    Product(
      imagePath: "assets/product/product1.png",
      title: "Mocha Frappe",
      price: "\$7.1",
      oldPrice: "\$10.0",
    ),
    Product(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      drawer: _buildSideBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsetsGeometry.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader,
                SizedBox(height: 12),
                _buildSearchbar,
                SizedBox(height: 12),
                _buildBody,
                SizedBox(height: 12),
                _buildCategories,
                SizedBox(height: 12),
                _buildFeaturedBeverages,
              ],
            ),
          ),
        ),
      ),
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
                authViewModel.currentUserName,
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
                  MaterialPageRoute(builder: (context) => Orders()),
                );
              },
              icon: const Icon(
                Icons.shopping_bag_outlined,
                size: 28,
                color: AppColors.primaryColor,
              ),
            ),
            IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu, size: 30, color: Colors.black),
            ),
          ],
        ),
      ],
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
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, color: Colors.grey, size: 28),
          ),
        ],
      ),
    );
  }

  Widget get _buildMenuItems {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.home_outlined,
            color: selectedIndex == 0 ? AppColors.primaryColor : Colors.grey,
          ),
          title: Text(
            "Home",
            style: TextStyle(
              color: selectedIndex == 0 ? AppColors.primaryColor : Colors.grey,
              fontWeight: selectedIndex == 0
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          onTap: () {
            setState(() {
              selectedIndex = 0;
            });
            Navigator.pop(context);
          },
        ),

        ListTile(
          leading: Icon(
            Icons.shopping_bag_outlined,
            color: selectedIndex == 1 ? AppColors.primaryColor : Colors.grey,
          ),
          title: Text(
            "My Order",
            style: TextStyle(
              color: selectedIndex == 1 ? AppColors.primaryColor : Colors.grey,
              fontWeight: selectedIndex == 1
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          onTap: () {
            setState(() {
              selectedIndex = 1;
            });
          },
        ),

        ListTile(
          leading: Icon(
            Icons.store_outlined,
            color: selectedIndex == 2 ? AppColors.primaryColor : Colors.grey,
          ),
          title: Text(
            "Store Location",
            style: TextStyle(
              color: selectedIndex == 2 ? AppColors.primaryColor : Colors.grey,
              fontWeight: selectedIndex == 2
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          onTap: () {
            setState(() {
              selectedIndex = 2;
            });
            Navigator.pop(context);
          },
        ),

        ListTile(
          leading: Icon(
            Icons.person_outline,
            color: selectedIndex == 3 ? AppColors.primaryColor : Colors.grey,
          ),
          title: Text(
            "Profile",
            style: TextStyle(
              color: selectedIndex == 3 ? AppColors.primaryColor : Colors.grey,
              fontWeight: selectedIndex == 3
                  ? FontWeight.bold
                  : FontWeight.normal,
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
        ),

        const Divider(color: Colors.black12),

        ListTile(
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
        ),
      ],
    );
  }

  Widget get _buildSearchbar {
    return Container(
      height: 58,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          Icon(Icons.search, color: Colors.black, size: 30),
        ],
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
          children: [
            const Text(
              "Featured Beverages",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
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
            ),
          ],
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
}
