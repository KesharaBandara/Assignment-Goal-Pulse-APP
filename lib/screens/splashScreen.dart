import 'dart:async';

import 'package:flutter/material.dart';
import 'package:goalpulse/screens/homeScreen.dart';
import 'package:provider/provider.dart';

import '../Provider/sign_in_provider.dart';
import '../provider/next_Screen.dart';
import 'loginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //init state

  @override
  void initState() {
    final sp = context.read<SignInProvider>();
    super.initState();

    //create a timer of 2 seconds
    Timer(const Duration(seconds: 2), () {
      sp.isSignedIn == false
          ? nextScreen(context, LoginScreen()) //if user didn't sign
          : nextScreen(context, HomeScreen()); //if user already signed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: 500,
      decoration: BoxDecoration(),
      child: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 120, bottom: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Image(
                image: AssetImage('assets/goalPulse.png'), //logo
                height: 256,
                width: 254,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
