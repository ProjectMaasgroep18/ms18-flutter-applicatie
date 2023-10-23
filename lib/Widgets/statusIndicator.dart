import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final Color color;
  const StatusIndicator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                ),
              ),
            );
  }
}