// Made by Joost Both 103674
import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Declarations/declarations.dart';
import 'package:ms18_applicatie/Declarations/declarationsPayout.dart';
import 'package:ms18_applicatie/roles.dart';
import '../../Declarations/pickPhoto.dart';
import '../../Widgets/paddingSpacing.dart';
import '../../config.dart';
import '../../menu.dart';

class DeclarationsMenu extends StatefulWidget {
  const DeclarationsMenu({Key? key}) : super(key: key);

  @override
  State<DeclarationsMenu> createState() => DeclarationsMenuState();
}

class DeclarationsMenuState extends State<DeclarationsMenu> {
  List<Widget> getButtons(BuildContext context) => [
        if (UserData.roles!.contains(Roles.Admin))
          ImageButton(
            subTitle: "Uitbetalen van declaraties",
            title: "Uitbetalen",
            onClick: () async {
              globToken = await getToken();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeclarationsPayout(),
                ),
              );
            },
          ),
        const PaddingSpacing(),
        ImageButton(
          image: 'assets/declarations/uploadtruck.png',
          subTitle: "Uploaden van declaraties voor goedkeuring",
          title: "Uploaden",
          onClick: () async {
            globToken = await getToken();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PickPhoto(),
              ),
            );
          },
        ),
        const PaddingSpacing(),
        if (UserData.roles!.contains(Roles.Admin))
          ImageButton(
            image: 'assets/declarations/approvetruck.png',
            subTitle: "Declaraties goedkeuren voor uitbetaling",
            title: "Goedkeuren",
            onClick: () async {
              globToken = await getToken();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Declarations(),
                ),
              );
            },
          ),
      ];

  @override
  Widget build(BuildContext context) {
    return Menu(
      title: const Text(
        "Declaraties",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(mobilePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getButtons(context),
          ),
        ),
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? image;
  final Function onClick;

  const ImageButton({
    super.key,
    this.image,
    required this.subTitle,
    required this.title,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onClick();
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.white,
        shadowColor: shadowColor,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: const BorderSide(
            color: Colors.grey,
            width: 1.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(mobilePadding * 1.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image != null) ...[
              Image(
                image: AssetImage(image!),
                width: 75,
                height: 75,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
            Text(
              title,
              style: const TextStyle(
                color: mainColor,
                fontSize: 30,
              ),
            ),
            Text(
              subTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
