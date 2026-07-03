import 'package:coffe_app/core/constants/theme/theme_cubit.dart';
import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:coffe_app/view_model/cart/cart_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

class AppBlocProvider {
  static final List<SingleChildWidget> _appBlocs = [
    BlocProvider<ThemeCubit>(
      create: (_) => ThemeCubit(),
    ),

    BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(),
    ),

    BlocProvider<CartCubit>(
      create: (_) => CartCubit()..loadCart(),
    ),
  ];

  static List<SingleChildWidget> getMainBlocProviderList() => _appBlocs;
}