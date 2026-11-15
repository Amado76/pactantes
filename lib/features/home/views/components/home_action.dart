import 'package:flutter/material.dart';

/// Provides touch feedback while Home destinations remain presentational.
class HomeAction extends StatelessWidget {
  const HomeAction({
    required this.child,
    this.decoration,
    this.onTap,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BoxDecoration? decoration;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: Ink(
      decoration: decoration,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius:
            decoration?.borderRadius?.resolve(Directionality.of(context)) ??
            BorderRadius.circular(8),
        child: child,
      ),
    ),
  );
}
