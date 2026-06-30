import 'package:coffe_app/core/constants/theme/app_theme.dart';
import 'package:coffe_app/core/constants/theme/theme_cubit.dart';
import 'package:coffe_app/core/constants/theme/theme_state.dart';
import 'package:coffe_app/core/router/app_router.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:coffe_app/view_model/auth/auth_state.dart';
import 'package:coffe_app/view_model/cart/cart_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(),
        ),
        BlocProvider<CartCubit>(
          create: (_) => CartCubit()..loadCart(),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) {
          if (current.status == AuthStatus.authenticated &&
              previous.status == AuthStatus.unauthenticated) {
            return true;
          }

          if (current.status == AuthStatus.unauthenticated &&
              previous.status == AuthStatus.authenticated) {
            return true;
          }

          return false;
        },
        listener: (context, state) {
          final cartCubit = context.read<CartCubit>();

          if (state.isAuthenticated) {
            cartCubit.onUserSignedIn();
            return;
          }

          if (state.isUnauthenticated) {
            cartCubit.onUserSignedOut();
          }
        },
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Coffe App',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeState.themeMode,
              routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}
