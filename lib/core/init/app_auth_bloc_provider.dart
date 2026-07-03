import 'package:coffe_app/view_model/auth/auth_cubit.dart';
import 'package:coffe_app/view_model/auth/auth_state.dart';
import 'package:coffe_app/view_model/cart/cart_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppAuthListener extends StatelessWidget {
  final Widget child;

  const AppAuthListener({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        return previous.status != current.status;
      },
      listener: (context, state) {
        final cartCubit = context.read<CartCubit>();

        if (state.isAuthenticated) {
          cartCubit.onUserSignedIn();
        }

        if (state.isUnauthenticated) {
          cartCubit.onUserSignedOut();
        }
      },
      child: child,
    );
  }
}