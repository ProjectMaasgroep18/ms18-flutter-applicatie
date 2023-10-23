import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Models/user.dart';
import 'package:ms18_applicatie/Widgets/statusIndicator.dart';
import '../config.dart';

class UserElement extends StatelessWidget {
  final User user;
  final Function(String)? onChange;

  const UserElement({
    required this.user,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: SizedBox(
          width: 45,
          height: 45,
          child: Stack(clipBehavior: Clip.none, children: [
            Container(
              decoration: BoxDecoration(
                // color: user,
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
                )),
          ]),
        ),
        title: Text(user.fullName),
        subtitle: Text(user.email));
  }
}
