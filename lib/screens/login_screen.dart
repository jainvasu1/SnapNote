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

  final String animationLink = 'assets/login-bear.riv';

  SMITrigger? failTrigger, successTrigger;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;
  StateMachineController? controller;
  Artboard? artboard;

  @override
  void initState() {
    super.initState();
    initRive();
  }

  // LOAD RIVE
  void initRive() async {
    final data = await rootBundle.load(animationLink);
    final file = RiveFile.import(data);
    final art = file.mainArtboard;

    controller = StateMachineController.fromArtboard(art, "Login Machine");

    if (controller != null) {
      art.addController(controller!);

      for (var input in controller!.inputs) {
        switch (input.name) {
          case "isChecking":
            isChecking = input as SMIBool;
            break;
          case "isHandsUp":
            isHandsUp = input as SMIBool;
            break;
          case "trigSuccess":
            successTrigger = input as SMITrigger;
            break;
          case "trigFail":
            failTrigger = input as SMITrigger;
            break;
          case "numLook":
            lookNum = input as SMINumber;
            break;
        }
      }
    }

    if (mounted) setState(() => artboard = art);
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  // ANIMATIONS
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

  // LOGIN FUNCTION
  void loginClick() async {
    isChecking?.change(false);
    isHandsUp?.change(false);

    // Validation
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      failTrigger?.fire();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Enter all fields ")));
      return;
    }

    // SUCCESS
    successTrigger?.fire();

    // Navigate after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.notesList);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // RIVE ANIMATION
              artboard != null
                  ? SizedBox(
                      width: 400,
                      height: 250,
                      child: Rive(artboard: artboard!),
                    )
                  : const CircularProgressIndicator(),

              const SizedBox(height: 20),

              // EMAIL FIELD
              Padding(
                padding: const EdgeInsets.all(15),
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
