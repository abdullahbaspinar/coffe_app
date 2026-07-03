import 'package:coffe_app/core/constants/theme/app_theme.dart';
import 'package:coffe_app/core/constants/theme/theme_cubit.dart';
import 'package:coffe_app/core/constants/theme/theme_state.dart';
import 'package:coffe_app/core/init/app_auth_bloc_provider.dart';
import 'package:coffe_app/core/init/app_bloc_provider.dart';
import 'package:coffe_app/core/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppBlocProvider.getMainBlocProviderList(),
      child: AppAuthListener(
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
