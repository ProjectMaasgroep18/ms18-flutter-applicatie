import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Widgets/statusIndicator.dart';
import 'package:ms18_applicatie/config.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, this.size = 45, this.url = ''});
  final double size;
  final String url;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(clipBehavior: Clip.none, children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              borderRadius,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(2, 2), // changes position of shadow
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Image.asset('assets/avaters/Avatar Default.png'),
        ),
        const Positioned(
          bottom: 0,
          right: -3,
          child: StatusIndicator(
            color: successColor,
          ),
        ),
      ]),
    );
  }
}
