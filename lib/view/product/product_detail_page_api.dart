import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view_model/card_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailPageApi extends StatefulWidget {
  final Product product;
  const ProductDetailPageApi({super.key, required this.product});

  @override
  State<ProductDetailPageApi> createState() => _ProductDetailPageApiState();
}

class _ProductDetailPageApiState extends State<ProductDetailPageApi> {
  int quantity = 1;

  final double rating = 4.8;

  void _showAddedToCartDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 42),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Successfully Added to Cart",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  "${widget.product.title} successfully added to cart.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: _buildAppBar,
      body: SingleChildScrollView(
        child: Column(children: [_buildTopSection, _buildBottomSection]),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
      ),
      title: Text(
        "Details",
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.favorite_border, color: Colors.white),
        ),
      ],
    );
  }

  Widget get _buildTopSection {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Image.network(
          widget.product.imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/product/product2/mocha.png",
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }

  Widget get _buildBottomSection {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleAndPrice,
          const SizedBox(height: 12),
          _buildCategoryAndRating,
          const SizedBox(height: 24),
          _buildDescription,
          const SizedBox(height: 24),
          _buildQuantitySelector,
          const SizedBox(height: 24),
          _buildAddToCartButton,
        ],
      ),
    );
  }

  Widget get _buildTitleAndPrice {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.product.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Text(
          "\$${widget.product.price.toStringAsFixed(2)}",
          style: const TextStyle(
            color: AppColors.primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget get _buildCategoryAndRating {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            widget.product.category,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Spacer(),
        const Icon(Icons.star, color: Colors.amber, size: 22),
        const SizedBox(width: 4),
        Text(
          rating.toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget get _buildDescription {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.product.description,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
            height: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget get _buildQuantitySelector {
    return Row(
      children: [
        const Text(
          "Quantity",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        _buildQuantityButton(
          icon: Icons.remove,
          onTap: () {
            if (quantity > 1) {
              setState(() {
                quantity--;
              });
            }
          },
        ),
        const SizedBox(width: 16),
        Text(
          quantity.toString(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 16),
        _buildQuantityButton(
          icon: Icons.add,
          onTap: () {
            setState(() {
              quantity++;
            });
          },
        ),
      ],
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget get _buildAddToCartButton {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () async {
          await context.read<CardViewModel>().addToCard(
            widget.product,
            quantity: quantity,
          );

          if (!mounted) return;
          _showAddedToCartDialog();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
        child: Text(
          "Add to Cart - \$${(widget.product.price * quantity).toStringAsFixed(2)}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
