import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view_model/home_view_model.dart';
import 'package:coffe_app/model/entity/category_entity.dart';
import 'package:coffe_app/model/entity/featured_beverage_entity.dart';
import 'package:coffe_app/model/entity/product_entity.dart';
import 'package:coffe_app/view/widgets/categories_card.dart';
import 'package:coffe_app/view/widgets/featured_beverages.dart';
import 'package:coffe_app/view/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
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
                _buildBody,
                const SizedBox(height: 12),
                _buildCategories,
                const SizedBox(height: 12),
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
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Abdullah",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_bag_outlined,
                size: 28,
                color: AppColors.primaryColor,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                size: 30,
                color: Colors.black,
              ),
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
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Icon(
            Icons.search,
            color: Colors.black,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget get _buildBody {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: viewModel.products.length,
        itemBuilder: (context, index) {
          final product = viewModel.products[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ProductCard(
              imagePath: product.imagePath,
              title: product.title,
              price: product.price,
              oldPrice: product.oldPrice,
              onTap: () {
                debugPrint("product card tıklandı");
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
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.categories.length,
            itemBuilder: (context, index) {
              final item = viewModel.categories[index];

              return Padding(
                padding: const EdgeInsets.all(2),
                child: CategoriesCard(
                  title: item.title,
                  menu_count: item.menu_count,
                  icon_name: item.icon_name,
                  onTap: () {
                    debugPrint("category card tıklandı");
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
              onPressed: () {},
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
          itemCount: viewModel.featuredBeverages.length,
          separatorBuilder: (context, index) => const SizedBox(height: 18),
          itemBuilder: (context, index) {
            final item = viewModel.featuredBeverages[index];

            return FeaturedBeverageItem(
              imagePath: item.imagePath,
              title: item.title,
              price: item.price,
              points: "${item.points} pts",
              rating: item.ratings,
              onTap: () {},
            );
          },
        ),
      ],
    );
  }
}

