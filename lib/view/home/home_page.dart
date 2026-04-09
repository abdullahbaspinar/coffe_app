import 'package:coffe_app/constants/app_colors.dart';
import 'package:coffe_app/view/widgets/product_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar,
      body: _buildBody,
    );
  }

  get _buildAppBar {
    return AppBar(title: Text("Anasayfa"));
  }

  Widget get _buildBody {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          ProductCard(
            imagePath: "assets/product/product1.png",
            title: "Creamy İce Coffe",
            price: "\$5.8",
            oldPrice: "\$9.9",
            onTap: () {
              print("product card tıklandı");
            },
          ),
        ],
      ),
    );
  }
}
