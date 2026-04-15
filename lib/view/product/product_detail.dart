import 'package:coffe_app/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 0;
  double selectedSize = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      backgroundColor: AppColors.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [_buildTopSection, _buildBottomCard, _buildRatingBadge],
        ),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back, color: AppColors.backgroundColor),
      ),
      title: const Text(
        "Details",
        style: TextStyle(
          color: AppColors.backgroundColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.bookmark_border,
            color: AppColors.backgroundColor,
          ),
        ),
      ],
    );
  }

  Widget get _buildTopSection {
    return SizedBox(
      width: double.infinity,
      height: 320,
      child: Center(
        child: SizedBox(
          child: Image.asset(
            "assets/product/product2.png",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget get _buildBottomCard {
    return Positioned(
      top: 280,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(36),
            topRight: Radius.circular(36),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              _buildProductHeader,
              const SizedBox(height: 16),
              _buildProductDescription,
              const SizedBox(height: 24),
              _buildSizeSelector,
              const SizedBox(height: 24),
              _buildPriceAndQuantityRow,
              const SizedBox(height: 32),
              _buildOrderButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _buildProductHeader {
    return const Text(
      "Ice Chocolate Coffee",
      style: TextStyle(
        color: Colors.black,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget get _buildProductDescription {
    return const Text(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do",
      style: TextStyle(
        color: Colors.grey,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
    );
  }

  Widget get _buildSizeSelector {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primaryColor,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: AppColors.primaryColor,
            overlayColor: AppColors.primaryColor.withValues(alpha: 0.15),
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13),
          ),
          child: Slider(
            value: selectedSize,
            min: 0,
            max: 3,
            divisions: 3,
            onChanged: (value) {
              setState(() {
                selectedSize = value;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Small",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Text(
              "Medium",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Text(
              "Large",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            Text(
              "Xtra Large",
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }

  Widget get _buildPriceAndQuantityRow {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildPriceSection),
        const SizedBox(width: 12),
        _buildQuantitySelector,
      ],
    );
  }

  Widget get _buildPriceSection {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          "\$ 5.8",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            "\$8.0",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ),
      ],
    );
  }

  Widget get _buildQuantitySelector {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              if (quantity > 0) {
                setState(() {
                  quantity--;
                });
              }
            },
            icon: const Icon(Icons.remove, color: AppColors.primaryColor),
          ),
          Text(
            "$quantity",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                quantity++;
              });
            },
            icon: const Icon(Icons.add, color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }



  Widget get _buildOrderButton {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: const Text(
          "PLACE ORDER   \$17.4",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget get _buildRatingBadge {
    return Positioned(
      top: 240,
      right: 24,
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.orangeAccent.withValues(alpha: 0.3),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "4.5",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
