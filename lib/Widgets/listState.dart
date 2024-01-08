import 'package:flutter/material.dart';
import 'package:ms18_applicatie/config.dart';

class ListLoadingIndicator extends StatelessWidget {
  const ListLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ListErrorIndicator extends StatelessWidget {
  const ListErrorIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Icon(
          Icons.error,
          color: dangerColor,
          size: 50,
        ),
      ),
    );
  }
}
