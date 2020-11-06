import 'package:flutter/material.dart';

class RouteAnimator extends PageRouteBuilder {
  Widget widget;
  RouteAnimator(this.widget)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => widget,
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation =
                CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
        );
}
