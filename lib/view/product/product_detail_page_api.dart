import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_size.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view/product/mixin/product_detail_api_page_mixin.dart';
import 'package:flutter/material.dart';

class ProductDetailPageApi extends StatefulWidget {
  final Product product;
  const ProductDetailPageApi({super.key, required this.product});

  @override
  State<ProductDetailPageApi> createState() => _ProductDetailPageApiState();
}

class _ProductDetailPageApiState extends State<ProductDetailPageApi>
    with ProductDetailApiPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appPrimary,
      appBar: _buildAppBar,
      body: SingleChildScrollView(
        child: Column(children: [_buildTopSection, _buildBottomSection]),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      backgroundColor: context.appPrimary,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => AppRouter.pop(),
        icon: Icon(Icons.arrow_back_ios_new, color: context.appBackground),
      ),
      title: Text(
        'Details',
        style: TextStyle(
          color: context.appBackground,
          fontSize: AppTypography.size22,
          fontWeight: AppTypography.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.favorite_border, color: context.appBackground),
        ),
      ],
    );
  }

  Widget get _buildTopSection {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Padding(
        padding: AppSpacing.padding24,
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/product/product2/mocha.png',
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
      padding: AppSpacing.padding24,
      decoration: BoxDecoration(
        color: context.appBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleAndPrice,
          const SizedBox(height: AppSpacing.s12),
          _buildCategoryAndRating,
          const SizedBox(height: AppSpacing.s24),
          _buildDescription,
          const SizedBox(height: AppSpacing.s24),
          _buildQuantitySelector,
          const SizedBox(height: AppSpacing.s24),
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
            product.title,
            style: TextStyle(
              color: context.appTextPrimary,
              fontSize: AppTypography.size24,
              fontWeight: AppTypography.extraBold,
            ),
          ),
        ),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: TextStyle(
            color: context.appPrimary,
            fontSize: AppTypography.size24,
            fontWeight: AppTypography.extraBold,
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
            color: context.appPrimaryTint,
            borderRadius: AppRadius.border(AppRadius.size20),
          ),
          child: Text(
            product.category,
            style: TextStyle(
              color: context.appPrimary,
              fontSize: AppTypography.size14,
              fontWeight: AppTypography.bold,
            ),
          ),
        ),
        const Spacer(),
        const Icon(Icons.star, color: AppColors.star, size: 22),
        SizedBox(width: AppSpacing.s4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            color: context.appTextPrimary,
            fontSize: AppTypography.size16,
            fontWeight: AppTypography.bold,
          ),
        ),
      ],
    );
  }

  Widget get _buildDescription {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            color: context.appTextPrimary,
            fontSize: AppTypography.size20,
            fontWeight: AppTypography.extraBold,
          ),
        ),
        const SizedBox(height: AppSpacing.s10),
        Text(
          product.description,
          style: TextStyle(
            color: context.appTextPrimary,
            fontSize: AppTypography.size15,
            height: 1.5,
            fontWeight: AppTypography.medium,
          ),
        ),
      ],
    );
  }

  Widget get _buildQuantitySelector {
    return Row(
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            color: context.appTextPrimary,
            fontSize: AppTypography.size20,
            fontWeight: AppTypography.extraBold,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.appBackground,
            borderRadius: AppRadius.border(AppRadius.size30),
            border: Border.all(color: context.appTextMuted),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: decrementQuantity,
                icon: Icon(Icons.remove, color: context.appPrimary),
              ),
              Text(
                '$quantity',
                style: TextStyle(
                  fontSize: AppTypography.size22,
                  fontWeight: AppTypography.bold,
                  color: context.appTextPrimary,
                ),
              ),
              IconButton(
                onPressed: incrementQuantity,
                icon: Icon(Icons.add, color: context.appPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get _buildAddToCartButton {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.searchBarHeight,
      child: ElevatedButton(
        onPressed: addToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.appPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.border(AppRadius.size30),
          ),
          elevation: 0,
        ),
        child: Text(
          'Add to Cart - \$${(product.price * quantity).toStringAsFixed(2)}',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: AppTypography.size18,
            fontWeight: AppTypography.extraBold,
          ),
        ),
      ),
    );
  }
}
