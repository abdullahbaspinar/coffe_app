import 'package:coffe_app/core/router/app_route_effect.dart';
import 'package:coffe_app/core/router/app_routes.dart';
import 'package:coffe_app/core/router/router_refresh.dart';
import 'package:coffe_app/core/router/transition_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coffe_app/model/category.dart';
import 'package:coffe_app/model/product.dart';
import 'package:coffe_app/model/user_profile.dart';
import 'package:coffe_app/view/auth/auth_choice_page.dart';
import 'package:coffe_app/view/auth/reset_password_page.dart';
import 'package:coffe_app/view/auth/sign_in_page.dart';
import 'package:coffe_app/view/auth/sign_up_page.dart';
import 'package:coffe_app/view/categories/all_categories.dart';
import 'package:coffe_app/view/home/home_page.dart';
import 'package:coffe_app/view/onboarding/onboarding_page.dart';
import 'package:coffe_app/view/orders/orders.dart';
import 'package:coffe_app/view/product/product_detail_page.dart';
import 'package:coffe_app/view/product/product_detail_page_api.dart';
import 'package:coffe_app/view/product/products.dart';
import 'package:coffe_app/view/profile/profile_edit.dart';
import 'package:coffe_app/view/profile/profile_page.dart';
import 'package:coffe_app/view/splash/splash_screen.dart';
import 'package:coffe_app/view/store_location/store_loaction.dart';
import 'package:coffe_app/view_model/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/single_child_widget.dart';

class ProfileEditExtra {
  final UserProfile profile;
  final ProfileCubit cubit;

  const ProfileEditExtra({
    required this.profile,
    required this.cubit,
  });
}

class AppRouter {
  AppRouter._();

  static final RouterRefresh _routerRefresh = RouterRefresh();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash.path,
    debugLogDiagnostics: true,
    refreshListenable: _routerRefresh,
    redirect: _redirect,
    routes: [
      _generateGoRoute(
        route: AppRoutes.splash.path,
        view: (_) => const SplashScreen(),
        routeEffect: AppRouteEffect.none,
      ),
      _generateGoRoute(
        route: AppRoutes.onboarding.path,
        view: (_) => const OnboardingPage(),
        routeEffect: AppRouteEffect.fade,
      ),
      _generateGoRoute(
        route: AppRoutes.auth.path,
        view: (_) => const AuthChoicePage(),
        routeEffect: AppRouteEffect.fade,
      ),
      _generateGoRoute(
        route: AppRoutes.signIn.path,
        view: (_) => const SignInPage(),
        routeEffect: AppRouteEffect.fade,
      ),
      _generateGoRoute(
        route: AppRoutes.signUp.path,
        view: (_) => const SignUpPage(),
        routeEffect: AppRouteEffect.fade,
      ),
      _generateGoRoute(
        route: AppRoutes.resetPassword.path,
        view: (_) => const ResetPasswordPage(),
        routeEffect: AppRouteEffect.fade,
      ),

      // ─── Ana uygulama ─────────────────────────────────────────
      _generateGoRoute(
        route: AppRoutes.home.path,
        view: (_) => const HomePage(),
        routeEffect: AppRouteEffect.none,
      ),
      _generateGoRoute(
        route: AppRoutes.categories.path,
        view: (_) => const AllCategories(),
        routeEffect: AppRouteEffect.fade,
      ),
      _generateGoRoute(
        route: AppRoutes.orders.path,
        view: (_) => const Orders(),
        routeEffect: AppRouteEffect.fade,
      ),
      _generateGoRoute(
        route: AppRoutes.profile.path,
        view: (_) => const ProfilePage(),
        routeEffect: AppRouteEffect.fade,
      ),
      _generateGoRoute(
        route: AppRoutes.profileEdit.path,
        view: (parameter) {
          final extra = parameter as ProfileEditExtra;
          return BlocProvider.value(
            value: extra.cubit,
            child: ProfileEditPage(profile: extra.profile),
          );
        },
        routeEffect: AppRouteEffect.fade,
      ),
      _generateGoRoute(
        route: AppRoutes.storeLocation.path,
        view: (_) => const StoreLocationPage(),
        routeEffect: AppRouteEffect.fade,
      ),

      _generateGoRoute(
        route: AppRoutes.productsByCategory.path,
        view: (parameter) {
          final map = parameter as Map<String, String>;
          return Products(
            category: Category(
              id: int.parse(map['categoryId']!),
              name: map['name'] ?? '',
              image: map['image'] ?? '',
            ),
          );
        },
        routeEffect: AppRouteEffect.fade,
      ),
      _generateGoRoute(
        route: AppRoutes.productDetail.path,
        view: (parameter) {
          return ProductDetailPageApi(product: parameter as Product);
        },
        routeEffect: AppRouteEffect.fade,
      ),
      _generateGoRoute(
        route: AppRoutes.productDetailLocal.path,
        view: (_) => const ProductDetail(),
        routeEffect: AppRouteEffect.fade,
      ),
    ],
  );

  static String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    final user = FirebaseAuth.instance.currentUser;

    if (location == AppRoutes.splash.path) {
      return null;
    }

    if (location == AppRoutes.onboarding.path) {
      return null;
    }

    final isAuthRoute = _isAuthRoute(location);

    if (user == null && !isAuthRoute) {
      return AppRoutes.signIn.path;
    }

    if (user != null && isAuthRoute) {
      return AppRoutes.home.path;
    }

    return null;
  }

  static bool _isAuthRoute(String location) {
    return location == AppRoutes.auth.path ||
        location == AppRoutes.signIn.path ||
        location == AppRoutes.signUp.path ||
        location == AppRoutes.resetPassword.path;
  }

  static GoRoute _generateGoRoute({
    required String route,
    required Widget Function(dynamic parameter) view,
    List<SingleChildWidget>? blocProviders,
    List<RouteBase>? subRoutes,
    AppRouteEffect routeEffect = AppRouteEffect.fade,
  }) {
    return GoRoute(
      name: route,
      path: route,
      routes: subRoutes ?? [],
      pageBuilder: (BuildContext context, GoRouterState state) {
        dynamic parameter;

        if (state.extra != null) {
          parameter = state.extra;
        } else if (state.pathParameters.isNotEmpty) {
          parameter = {
            ...state.pathParameters,
            ...state.uri.queryParameters,
          };
        }

        final Widget child = blocProviders != null
            ? MultiBlocProvider(
                providers: blocProviders,
                child: view(parameter),
              )
            : view(parameter);

        if (routeEffect == AppRouteEffect.none) {
          return MaterialPage(
            key: state.pageKey,
            child: child,
          );
        }

        return CustomTransitionPage(
          key: state.pageKey,
          child: child,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
          ) {
            return PageRouteTransitionBuilder.transitionsBuilder(
              context,
              animation,
              secondaryAnimation,
              child,
              effect: routeEffect,
            );
          },
        );
      },
    );
  }


  static void goNamed(
    String routeName, {
    Object? extra,
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
  }) {
    router.goNamed(
      routeName,
      extra: extra,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
    );
  }

  static Future<T?> navigatePushNamed<T>(
    String routeName, {
    Object? extra,
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
  }) {
    return router.pushNamed<T>(
      routeName,
      extra: extra,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
    );
  }

  static void navigatePushReplacementNamed(
    String routeName, {
    Object? extra,
    Map<String, String>? pathParameters,
    Map<String, String>? queryParameters,
  }) {
    router.pushReplacementNamed(
      routeName,
      extra: extra,
      pathParameters: pathParameters ?? {},
      queryParameters: queryParameters ?? {},
    );
  }

  static void openProductsByCategory(Category category) {
    navigatePushNamed(
      AppRoutes.productsByCategory.path,
      pathParameters: {'categoryId': '${category.id}'},
      queryParameters: {
        'name': category.name,
        'image': category.image,
      },
    );
  }

  static void openProductDetail(Product product) {
    navigatePushNamed(
      AppRoutes.productDetail.path,
      pathParameters: {'id': '${product.id}'},
      extra: product,
    );
  }

  static void pop<T extends Object?>({T? value}) {
    router.pop(value);
  }

  
}