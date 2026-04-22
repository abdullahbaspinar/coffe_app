import 'package:coffe_app/view/auth/auth_choice_page.dart';
import 'package:coffe_app/view/auth/sign_in_page.dart';
import 'package:coffe_app/view/auth/sign_up_page.dart';
import 'package:coffe_app/view/home/home_page.dart';
import 'package:coffe_app/view/onboarding/onboarding_page.dart';
import 'package:coffe_app/view/product/product_detail_page.dart';
import 'package:coffe_app/view/product/products.dart';
import 'package:coffe_app/view/splash/splash_screen.dart';
import 'package:coffe_app/view_model/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Coffe App',
        home: const HomePage(),
      ),
    );
  }
}
