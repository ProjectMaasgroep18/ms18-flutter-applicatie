import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Dashboard/dashboard.dart';
import 'package:ms18_applicatie/Profile/profile.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/menu.dart';

class Les extends StatelessWidget {
  Les({super.key});

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Menu(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Container(
              width: 200,
              height: 50,
              color: Colors.red,
              child: Center(
                child: Text(
                  'Text',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                './assets/logo.jpg',
                width: 50,
                height: 50,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {},
                child: Text('button'),
              )
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Test label",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InputField(
                  labelText: "dwdw",
                ),
                SizedBox(
                  height: 20,
                ),
                Button(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(),
                      ),
                    );
                  },
                  icon: Icons.add,
                  text: "submit",
                ),
              ],
            ),
          ),
          MyIcon(icon: Icons.people)
        ],
      ),
    );
  }
}

class MyIcon extends StatelessWidget {
  final IconData icon;
  const MyIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: Colors.red,
    );
  }
}
