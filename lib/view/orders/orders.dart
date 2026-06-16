import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/widgets/complete_orders_button.dart';
import 'package:coffe_app/view/widgets/total_amount.dart';
import 'package:coffe_app/model/card_item.dart'; // CardItem modelini import ettik
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffe_app/view_model/cart/cart_cubit.dart';
import 'package:coffe_app/view_model/cart/cart_state.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
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
              Expanded(
                child: BlocBuilder<CardCubit, CardState>(
                  builder: (context, state) {
                    return _buildProducts(state);
                  },
                ),
              ),
              const SizedBox(height: 8),
              const TotalAmount(),
              const SizedBox(height: 8),
              const CompleteOrdersButton(),
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
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      title: const Text(
        "Orders",
        style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w700),
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
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
          const Icon(Icons.search, color: Colors.black, size: 30),
        ],
      ),
    );
  }

  Widget _buildProducts(CardState state) {
    if (state is CardInitial || state is CardLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is CardError) {
      return Center(child: Text(state.errorMessage, style: const TextStyle(color: Colors.red)));
    }

    final query = _searchQuery.trim().toLowerCase();
    final loadedState = state as CardLoaded;

    final filteredItems = loadedState.items.where((item) {
      final title = item.product.title.toLowerCase();
      return title.contains(query);
    }).toList();

    if (loadedState.items.isEmpty) {
      return const Center(child: Text("Sepet Boş"));
    }

    if (filteredItems.isEmpty) {
      return const Center(child: Text("Sepette böyle bir ürün yok"));
    }

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        return _buildCartItem(filteredItems[index]);
      },
    );
  }

  Widget _buildCartItem(CardItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.imageUrl, 
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/product/product2/mocha.png",
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "\$${item.product.price}",
                        style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        "Total: \$${(item.quantity * item.product.price).toStringAsFixed(1)}",
                        style: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600),
                      )
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => _handleDecreaseAction(item),
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                ),
                Text(
                  "${item.quantity}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    context.read<CardCubit>().quantityPlus(item.product);
                  },
                  icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🚀 SİLME DİYALOGUNU YÖNETEN TEMİZ METOD
  void _handleDecreaseAction(CardItem item) {
    if (item.quantity > 1) {
      context.read<CardCubit>().quantityNotPlus(item.product);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text("Ürünü Sil"),
            content: Text("${item.product.title} sepetten silinsin mi?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text("Hayır", style: TextStyle(color: AppColors.primaryColor)),
              ),
              TextButton(
                onPressed: () {
                  context.read<CardCubit>().deleteFromCard(item.product);
                  Navigator.pop(dialogContext);
                },
                child: const Text("Evet", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    }
  }
}