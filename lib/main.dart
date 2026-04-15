import 'package:coffe_app/view/auth/auth_choice_page.dart';
import 'package:coffe_app/view/auth/sign_in_page.dart';
import 'package:coffe_app/view/auth/sign_up_page.dart';
import 'package:coffe_app/view/home/home_page.dart';
import 'package:coffe_app/view/onboarding/onboarding_page.dart';
import 'package:coffe_app/view/product/product_detail.dart';
import 'package:coffe_app/view/splash/splash_screen.dart';
import 'package:coffe_app/view/splash/splash_screen.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const ProductDetail(),
    );
  }
}
