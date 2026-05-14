import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/widgets/complete_orders_button.dart';
import 'package:coffe_app/view/widgets/orders_card.dart';
import 'package:coffe_app/view/widgets/total_amount.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffe_app/view_model/card_view_model.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  CardViewModel get cart => context.watch<CardViewModel>();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildSearchBar,
              const SizedBox(height: 8),
              Expanded(child: _buildProducts(cart)),
              const SizedBox(height: 8),
              TotalAmount(),
              const SizedBox(height: 8),
              CompleteOrdersButton(),
            ],
          ),
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
        "Orders",
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

  Widget get _buildSearchBar {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
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

  Widget _buildProducts(CardViewModel cart) {
    final query = _searchQuery.trim().toLowerCase();

    final filteredItems = cart.items.where((item) {
      final title = item.product.title.toLowerCase();
      return title.contains(query);
    }).toList();

    if (cart.items.isEmpty) {
      return const Center(child: Text("Sepet Boş"));
    }
    if(filteredItems.isEmpty) {
      return const Center(child: Text("Sepette böyle bir ürün yok"));
    }
    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return OrdersCard(
          imagePath: item.product.imageUrl,
          title: item.product.title,
          price: item.product.price,
          count: item.quantity,
          onTap: () {},
          onIncrease: () => cart.increaseQuantity(item.product),
          onDecrease: () => cart.decreaseQuantity(item.product),
          onDelete: () => cart.removeFromCard(item.product),
        );
      },
    );
  }
}
