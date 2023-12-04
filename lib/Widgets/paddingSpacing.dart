import 'package:flutter/material.dart';
import 'package:ms18_applicatie/config.dart';

class PagePadding extends StatelessWidget {
  final Widget child;
  const PagePadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(mobilePadding),
      child: child,
    );
  }
}

class PaddingSpacing extends StatelessWidget {
  const PaddingSpacing({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: mobilePadding,
      height: mobilePadding,
    );
  }
}
