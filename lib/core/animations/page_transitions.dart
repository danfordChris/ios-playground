import 'package:flutter/material.dart';

class FadePageRoute<T> extends PageRoute<T> {
  FadePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget page;
  final Duration duration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(opacity: animation, child: page);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;
}

class SlidePageRoute<T> extends PageRoute<T> {
  SlidePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
  });

  final Widget page;
  final Duration duration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final tween = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero);
    return SlideTransition(position: animation.drive(tween), child: page);
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;
}

class ScalePageRoute<T> extends PageRoute<T> {
  ScalePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 350),
  });

  final Widget page;
  final Duration duration;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final tween = Tween<double>(begin: 0.9, end: 1.0);
    return ScaleTransition(
      scale: animation.drive(tween),
      child: FadeTransition(opacity: animation, child: page),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;
}
