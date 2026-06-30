import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/view/orders/mixin/orders_page_mixin.dart';
import 'package:coffe_app/view/widgets/complete_orders_button.dart';
import 'package:coffe_app/view/widgets/total_amount.dart';
import 'package:coffe_app/model/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_size.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffe_app/view_model/cart/cart_cubit.dart';
import 'package:coffe_app/view_model/cart/cart_state.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with OrdersPageMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.padding12,
          child: Column(
            children: [
              _buildSearchBar,
              const SizedBox(height: AppSpacing.s8),
              Expanded(
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, state) {
                    return _buildProducts(state);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              const TotalAmount(),
              const SizedBox(height: AppSpacing.s8),
              const CompleteOrdersButton(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget get _buildAppBar {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: EdgeInsets.only(left: 12),
        child: IconButton(
          onPressed: closePage,
          icon: Icon(Icons.arrow_back_ios_new, color: context.appTextPrimary),
        ),
      ),
      title: Text(
        "Orders",
        style: TextStyle(
          color: context.appTextPrimary,
          fontSize: AppTypography.size22,
          fontWeight: AppTypography.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_horiz, color: context.appTextPrimary, size: 28),
        ),
      ],
    );
  }

  Widget get _buildSearchBar {
    return Container(
      height: AppSizes.searchBarHeight,
      padding: AppSpacing.paddingH16,
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: AppRadius.border(AppRadius.size30),
        border: Border.all(color: context.appTextPrimary, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: AppTypography.size16,
                  color: context.appTextMuted,
                ),
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

  Widget _buildProducts(CartState state) {
    if (state is CartInitial || state is CartLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CartError) {
      return RefreshIndicator(
        onRefresh: refreshCart,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: Center(
                child: Text(
                  state.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final loadedState = state as CartLoaded;
    final items = filterCartItems(loadedState);

    if (loadedState.items.isEmpty) {
      return RefreshIndicator(
        onRefresh: refreshCart,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: const Center(child: Text('Sepet Boş')),
            ),
          ],
        ),
      );
    }

    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: refreshCart,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.5,
              child: const Center(
                child: Text('Sepette böyle bir ürün yok'),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refreshCart,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildCartItem(items[index]);
        },
      ),
    );
  }

  Widget _buildCartItem(CartItem item) {
    return InkWell(
      onTap: () => openProductDetail(item.product),
      child: Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: AppSpacing.padding12,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: AppRadius.border(AppRadius.size8),
              child: Image.network(
                item.product.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/image_coming_soon.png",
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.s16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: const TextStyle(
                      fontSize: AppTypography.size16,
                      fontWeight: AppTypography.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Row(
                    children: [
                      Text(
                        "\$${item.product.price}",
                        style: TextStyle(
                          color: context.appPrimary,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "Total: \$${(item.quantity * item.product.price).toStringAsFixed(1)}",
                        style: TextStyle(
                          color: context.appPrimary,
                          fontWeight: AppTypography.semiBold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => handleDecreaseAction(item),
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: AppColors.error,
                  ),
                ),
                Text(
                  "${item.quantity}",
                  style: const TextStyle(
                    fontSize: AppTypography.size16,
                    fontWeight: AppTypography.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => incrementQuantity(item.product),
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: context.appPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }
}
