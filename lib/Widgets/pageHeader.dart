import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/config.dart';

class PageHeader extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();
  final Function() onAdd;
  final String title;
  PageHeader({super.key, required this.title,required this.onAdd });

  @override
  Widget build(BuildContext context) {
    return PagePadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Expanded(
                flex: 7,
                child: InputField(
                  icon: Icons.search,
                  hintText: "Search",
                ),
              ),
              const PaddingSpacing(),
              Expanded(
                flex: 3,
                child: Button(onTap: onAdd, icon: Icons.add)
              )
            ],
          ),
          const PaddingSpacing(),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            color: secondColor,
            height: 1,
          ),
        ],
      ),
    );
  }
}
