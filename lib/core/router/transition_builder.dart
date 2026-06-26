import 'package:coffe_app/core/router/app_route_effect.dart';
import 'package:flutter/cupertino.dart';

class PageRouteTransitionBuilder {
  static Widget transitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child, {
    Curve? curve = Curves.ease,
    AppRouteEffect effect = AppRouteEffect.rightToLeft,
  }) {
    switch (effect) {
      case AppRouteEffect.none:
      case AppRouteEffect.fade:
        return FadeTransition(opacity: animation, child: child);
      case AppRouteEffect.scale:
        return ScaleTransition(scale: animation, child: child);
      default:
        var tween = Tween(begin: effect.value, end: Offset.zero)
            .chain(CurveTween(curve: curve!));
        return SlideTransition(
          transformHitTests: false,
          position: animation.drive(tween),
          child: child,
        );
    }
  }
}