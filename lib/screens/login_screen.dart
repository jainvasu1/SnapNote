import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../constants/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  var animationLink = 'assets/login-bear.riv';

  SMITrigger? failTrigger, successTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;
  StateMachineController? stateMachineController;
  Artboard? artboard;

  @override
  void initState() {
    super.initState();

    rootBundle.load(animationLink).then((value) {
      final file = RiveFile.import(value);
      final art = file.mainArtboard;

      stateMachineController = StateMachineController.fromArtboard(
        art,
        "Login Machine",
      );

      if (stateMachineController != null) {
        art.addController(stateMachineController!);

        for (var element in stateMachineController!.inputs) {
          switch (element.name) {
            case "isChecking":
              isChecking = element as SMIBool;
              break;
            case "isHandsUp":
              isHandsUp = element as SMIBool;
              break;
            case "trigSuccess":
              successTrigger = element as SMITrigger;
              break;
            case "trigFail":
              failTrigger = element as SMITrigger;
              break;
            case "numLook":
              lookNum = element as SMINumber;
              break;
          }
        }
      }

      setState(() => artboard = art);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  // Animation Controls
  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
  }

  void moveEyes(String value) {
    lookNum?.change(value.length.toDouble());
  }

  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  // LOGIN LOGIC + ROUTING
  void loginClick() {
    isChecking?.change(false);
    isHandsUp?.change(false);

    if (emailController.text == "email" && passController.text == "pass") {
      successTrigger?.fire();

      // Navigate after slight delay (so animation plays)
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pushReplacementNamed(context, AppRoutes.notesList);
      });
    } else {
      failTrigger?.fire();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // RIVE ANIMATION
              if (artboard != null)
                SizedBox(
                  width: 400,
                  height: 250,
                  child: Rive(artboard: artboard!),
                ),

              // EMAIL FIELD
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  height: 70,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextFormField(
                    onTap: lookAround,
                    onChanged: moveEyes,
                    controller: emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none,
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              // PASSWORD FIELD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  height: 70,
                  width: 350,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: TextFormField(
                    onTap: handsUpOnEyes,
                    obscureText: true,
                    controller: passController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(15),
                      border: InputBorder.none,
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),

              // SIGNUP
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Not having account? Sign up!',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              const SizedBox(height: 10),

              // LOGIN BUTTON
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: MaterialButton(
                  onPressed: loginClick,
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
