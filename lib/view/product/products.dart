import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/product/product_detail_page.dart';
import 'package:coffe_app/view/widgets/products_card.dart';
import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: _buildAppBar,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSearchbar,
            ),
            const SizedBox(height: 24),
            _buildTabBar,
            Expanded(
              child: TabBarView(
                children: [
                  _buildBeverages,
                  _buildBrewedCoffee,
                  _buildBlendedCoffee,
                ],
              ),
            ),
          ],
        ),
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      title: const Text(
        "Products",
        style: TextStyle(
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

  Widget get _buildTabBar {
    return const TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: Color(0xFF1D2235),
      unselectedLabelColor: Color(0xFF8F939B),
      labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      unselectedLabelStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      indicatorColor: Color(0xFF0E7A4F),
      indicatorWeight: 3,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      tabs: [
        Tab(text: "Breverages"),
        Tab(text: "Brewed Coffee"),
        Tab(text: "Blended Coffee"),
      ],
    );
  }

  Widget get _buildBeverages {
    return Center(
      child: Column(
        children: [
          ProductsCard(
            imagePath: "assets/product/product2/mocha.png",
            title: "Mocha",
            category: "Beverages",
            price: 24,
            rating: 3.8,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetail()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget get _buildBrewedCoffee {
    return Center(
      child: Column(
        children: [
          ProductsCard(
            imagePath: "assets/product/product2/tea.png",
            title: "Tea",
            category: "Brewed Coffe",
            price: 12,
            rating: 4.8,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetail()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget get _buildBlendedCoffee {
    return Center(
      child: Column(
        children: [
          ProductsCard(
            imagePath: "assets/product/product2/mocha.png",
            title: "Mocha",
            category: "Blended Coffee",
            price: 24,
            rating: 3.8,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetail()),
              );
            },
          ),
        ],
      ),
    );
  }
}
