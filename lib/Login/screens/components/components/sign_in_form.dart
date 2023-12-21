import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Dashboard/dashboard.dart';
import 'package:ms18_applicatie/Dashboard/guestDashboard.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/popups.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/menu.dart';
import 'package:rive/rive.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowConfetti = false;

  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static const String url = "api/v1/User/Login";

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void signIn(BuildContext context) {
    setState(() {
      isShowConfetti = true;
    });
    if (_formKey.currentState!.validate()) {

      confetti.fire();
    } else {
      error.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputField(
                  labelText: "Email",
                  isUnderlineBorder: true,
                  controller: emailController,
                ),
                const PaddingSpacing(),
                const PaddingSpacing(),
                InputField(
                  labelText: "Password",
                  isUnderlineBorder: true,
                  isPassword: true,
                  controller: passwordController,
                ),
                const PaddingSpacing(),
                const PaddingSpacing(),
                const PaddingSpacing(),
                Button(
                  onTap: () async {
                    Map<String, String> body = {
                      'email': emailController.text,
                      'password': passwordController.text,
                    };
                    PopupAndLoading.showLoading();
                    await ApiManager.post(url, body).then((value) {
                      Map<String, dynamic> response = value;
                      if (response["token"] != null) {
                        setToken(response["token"]);
                        setPrefString(
                            response["member"]["permissions"][0], "role");
                        signIn(context);
                      }
                    }).catchError((error) {
                      print("ERROR: $error");
                      PopupAndLoading.showError(
                          "Inloggen mislukt probeer het nog eens!");
                    });
                    PopupAndLoading.endLoading();
                  },
                  text: 'Sign in',
                  icon: Icons.arrow_forward,
                ),
              ],
            )),
        isShowConfetti
            ? CustomPositioned(
                child: Transform.scale(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: (artboard) async {
                    StateMachineController controller =
                        getRiveController(artboard);
                    confetti =
                        controller.findSMI("Trigger explosion") as SMITrigger;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GuestDashboard(),
                      ),
                    );
                  },
                ),
              ))
            : const SizedBox()
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, required this.child, this.size = 100});
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: size,
            width: size,
            child: child,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
