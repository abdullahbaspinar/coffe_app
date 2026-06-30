import 'package:coffe_app/core/constants/app_colors.dart';
import 'package:coffe_app/core/constants/app_typography.dart';
import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/model/cart_item.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/view/orders/orders.dart';
import 'package:coffe_app/view_model/cart/cart_cubit.dart';
import 'package:coffe_app/view_model/cart/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin OrdersPageMixin on State<Orders> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged(String value) {
    setState(() => searchQuery = value);
  }

  List<CartItem> filterCartItems(CartLoaded state) {
    final query = searchQuery.trim().toLowerCase();
    return state.items.where((item) {
      final title = item.product.title.toLowerCase();
      return title.contains(query);
    }).toList();
  }

  void openProductDetail(Product product) {
    AppRouter.openProductDetail(product);
  }

  void closePage() {
    AppRouter.pop();
  }

  void handleDecreaseAction(CartItem item) {
    if (item.quantity > 1) {
      context.read<CartCubit>().quantityDecrease(item.product);
    } else {
      showDeleteDialog(item);
    }
  }

  void showDeleteDialog(CartItem item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Ürünü Sil'),
          content: Text('${item.product.title} sepetten silinsin mi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Hayır',
                style: TextStyle(color: context.appPrimary),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<CartCubit>().deleteFromCart(item.product);
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Evet',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: AppTypography.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void incrementQuantity(Product product) {
    context.read<CartCubit>().quantityPlus(product);
  }

  Future<void> refreshCart() {
    return context.read<CartCubit>().loadCart();
  }
}
