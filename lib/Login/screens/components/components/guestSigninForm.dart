import 'package:flutter/material.dart';
import 'package:ms18_applicatie/Api/apiManager.dart';
import 'package:ms18_applicatie/Dashboard/guestDashboard.dart';
import 'package:ms18_applicatie/Widgets/buttons.dart';
import 'package:ms18_applicatie/Widgets/inputFields.dart';
import 'package:ms18_applicatie/Widgets/paddingSpacing.dart';
import 'package:ms18_applicatie/Widgets/popups.dart';
import 'package:ms18_applicatie/config.dart';
import 'package:ms18_applicatie/main.dart';
import 'package:rive/rive.dart';

class GuestSignInForm extends StatefulWidget {
  const GuestSignInForm({
    super.key,
  });

  @override
  State<GuestSignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<GuestSignInForm> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;

  late SMITrigger confetti;

  TextEditingController emailController = TextEditingController();

  static const String url = "api/v1/User/Login";

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void signIn(BuildContext context) {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      if (_formKey.currentState!.validate()) {
        // show success
        check.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
          confetti.fire();
        });
      } else {
        error.fire();
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
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
                const PaddingSpacing(),
                const PaddingSpacing(),
                const PaddingSpacing(),
                Button(
                  onTap: () async {
                    PopupAndLoading.showLoading();

                    Map<String, String> body = {
                      'email': emailController.text,
                      'password': ''
                    };
                    await ApiManager.post(url, body).then((value) {
                      Map<String, dynamic> response = value;
                      if(response["token"] != null) {
                        setToken(response["token"]);
                        setPrefString(response["member"]["permissions"][0], "role");
                        signIn(context);
                        loadLocalUser(response["member"]);
                      }else{
                        throw Exception("Login failed, check creds");
                      }
                    }).catchError((error) {
                      print(error);
                      PopupAndLoading.showError("Inloggen mislukt, probeer het nog eens");
                    });
                    PopupAndLoading.endLoading();

                  },
                  text: 'Inloggen',
                  icon: Icons.arrow_forward,
                ),
              ],
            )),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                "assets/RiveAssets/check.riv",
                onInit: (artboard) {
                  StateMachineController controller =
                      getRiveController(artboard);
                  check = controller.findSMI("Check") as SMITrigger;
                  error = controller.findSMI("Error") as SMITrigger;
                  reset = controller.findSMI("Reset") as SMITrigger;
                },
              ))
            : const SizedBox(),
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
                    await Future.delayed(const Duration(seconds: 5), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GuestDashboard(),
                        ),
                      );
                    });
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
