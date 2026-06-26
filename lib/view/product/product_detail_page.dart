import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity = 1;
  double selectedSize = 1;
  double productPrice = 5.8;
  double oldPrice = 8.0;

  double get totalPrice => productPrice * quantity;

  bool isBookMarked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      backgroundColor: context.appPrimary,
      body: Column(
        children: [
          _buildTopSection,
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                _buildBottomCard,

                Positioned(child: _buildRatingBadge, top: -42, right: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => AppRouter.pop(),
        icon: Icon(Icons.arrow_back, color: context.appBackground),
      ),
      title: Text(
        "Details",
        style: TextStyle(
          color: context.appBackground,
          fontSize: AppTypography.size24,
          fontWeight: AppTypography.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isBookMarked = !isBookMarked;
            });
          },
          icon:  Icon(
            isBookMarked ? Icons.bookmark : Icons.bookmark_border,
            color: context.appBackground,
          ),
        ),
      ],
    );
  }

  Widget get _buildTopSection {
    return SizedBox(
      width: double.infinity,
      height: 200,
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
    return Container(
      height: double.infinity,
      padding: AppSpacing.padding24,
      decoration: BoxDecoration(
        color: context.appBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.s30),
            _buildProductHeader,
            const SizedBox(height: AppSpacing.s16),
            _buildProductDescription,
            const SizedBox(height: AppSpacing.s24),
            _buildSizeSelector,
            const SizedBox(height: AppSpacing.s24),
            _buildPriceAndQuantityRow,
            const SizedBox(height: AppSpacing.s32),
            _buildOrderButton,
          ],
        ),
      ),
    );
  }

  Widget get _buildProductHeader {
    return Text(
      "Ice Chocolate Coffee",
      style: TextStyle(
        color: context.appTextPrimary,
        fontSize: AppTypography.size28,
        fontWeight: AppTypography.bold,
      ),
    );
  }

  Widget get _buildProductDescription {
    return Text(
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do",
      style: TextStyle(
        color: context.appTextMuted,
        fontSize: AppTypography.size18,
        fontWeight: AppTypography.regular,
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
            activeTrackColor: context.appPrimary,
            inactiveTrackColor: AppColors.border,
            thumbColor: context.appPrimary,
            overlayColor: context.appPrimaryTint,
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
        const SizedBox(height: AppSpacing.s12),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Small",
              style: TextStyle(fontSize: AppTypography.size18, color: context.appTextPrimary),
            ),
            Text(
              "Medium",
              style: TextStyle(fontSize: AppTypography.size18, color: context.appTextPrimary),
            ),
            Text(
              "Large",
              style: TextStyle(fontSize: AppTypography.size18, color: context.appTextPrimary),
            ),
            Text(
              "Xtra Large",
              style: TextStyle(fontSize: AppTypography.size18, color: context.appTextPrimary),
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
        const SizedBox(width: AppSpacing.s12),
        _buildQuantitySelector,
      ],
    );
  }

  Widget get _buildPriceSection {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "\$ 5.8",
          style: TextStyle(
            fontSize: AppTypography.size36,
            fontWeight: AppTypography.bold,
            color: context.appTextPrimary,
          ),
        ),
        SizedBox(width: AppSpacing.s10),
        Padding(
          padding: EdgeInsets.only(bottom: 6),
          child: Text(
            "\$8.0",
            style: TextStyle(
              fontSize: AppTypography.size18,
              color: context.appTextMuted,
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
        color: context.appBackground,
        borderRadius: AppRadius.border(AppRadius.size30),
        border: Border.all(color: context.appTextMuted),
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
            icon: Icon(Icons.remove, color: context.appPrimary),
          ),
          Text(
            "$quantity",
            style: TextStyle(
              fontSize: AppTypography.size22,
              fontWeight: AppTypography.bold,
              color: context.appTextPrimary,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                quantity++;
              });
            },
            icon: Icon(Icons.add, color: context.appPrimary),
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
        onPressed: () {
          AppRouter.navigatePushNamed(AppRoutes.orders.path);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: context.appPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.border(AppRadius.size30),
          ),
          elevation: 0,
        ),
        child: Text(
          "PLACE ORDER  \$ ${totalPrice.toStringAsFixed(1)}",
          style: TextStyle(
            fontSize: AppTypography.size20,
            fontWeight: AppTypography.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Widget get _buildRatingBadge {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: AppColors.accentOrange,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.accentOrange.withValues(alpha: 0.3),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "4.5",
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppTypography.size24,
            fontWeight: AppTypography.bold,
          ),
        ),
      ),
    );
  }
}
