import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/core/router/app_routes.dart';
import 'package:coffe_app/view/product/product_detail_page.dart';
import 'package:flutter/material.dart';

mixin ProductDetailLocalPageMixin on State<ProductDetail> {
  int quantity = 1;
  double selectedSize = 1;
  double productPrice = 5.8;
  double oldPrice = 8.0;
  bool isBookMarked = false;

  double get totalPrice => productPrice * quantity;

  void toggleBookmark() {
    setState(() => isBookMarked = !isBookMarked);
  }

  void incrementQuantity() {
    setState(() => quantity++);
  }

  void decrementQuantity() {
    if (quantity > 0) {
      setState(() => quantity--);
    }
  }

  void onSizeChanged(double value) {
    setState(() => selectedSize = value);
  }

  void placeOrder() {
    AppRouter.navigatePushNamed(AppRoutes.orders.path);
  }

  void closePage() {
    AppRouter.pop();
  }
}
