import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goalpulse/screens/homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

import '../../Provider/internet_provider.dart';
import '../../Provider/sign_in_provider.dart';
import '../provider/next_Screen.dart';
import '../provider/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  //firebase
  final _auth = FirebaseAuth.instance;

  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controller

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RoundedLoadingButtonController googleController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    Widget emailField = buildEmailField(width);
    Widget passwordField = buildPasswordField(width);
    Widget loginButton = buildLoginButton(width, height);
    RoundedLoadingButtonController googleController =
        RoundedLoadingButtonController();
    //backward navigation disable
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildLogo(width, height),
                  buildTitle(),
                  SizedBox(height: height * 0.01),
                  emailField,
                  SizedBox(height: height * 0.02),
                  passwordField,
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Container(
                        alignment: Alignment.bottomRight,
                        child: buildResetPasswordLink()),
                  ),
                  SizedBox(height: height * 0.05),
                  loginButton,
                  SizedBox(height: height * 0.01),
                  Text(
                    'or',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(FontAwesomeIcons.google),
                        onPressed: () {
                          handleGoogleSignIn();
                        },
                        color: Colors.red,
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.facebookF),
                        onPressed: () {
                          // TODO: Facebook Sign-In logic
                        },
                        color: Colors.blueAccent,
                      ),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.twitter),
                        onPressed: () {
                          // TODO: Twitter Sign-In logic
                        },
                        color: Colors.lightBlueAccent,
                      ),
                    ],
                  ),
                  CustomPaint(
                    size: Size(double.infinity,
                        200), // You can change the size as needed
                    painter: RPSCustomPainter(),
                    child: Container(
                      height: 150,
                      alignment: Alignment.center,
                      child: Text(
                        'Goal Pulse Inc\nV.1.0.1',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//email text Field
  Widget buildEmailField(double width) {
    return SizedBox(
      width: width * 0.90,
      child: TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your email";
          }
          if (!RegExp(
                  "^[a-zA-Z0-9.a-zA-Z0-9.!#%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return "Please enter a valid email";
          }
          return null;
        },
        onSaved: (value) => emailController.text = value!,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

//email Password Field
  Widget buildPasswordField(double width) {
    return SizedBox(
      width: width * 0.90,
      child: TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password is required for login";
          }
          if (!RegExp(r'^.{6,}$').hasMatch(value)) {
            return "Enter a valid password (min 6 characters)";
          }
          return null;
        },
        onSaved: (value) => passwordController.text = value!,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

//LoginButton widget
  Widget buildLoginButton(double width, double height) {
    return SizedBox(
      width: width * 0.75,
      height: height * 0.069,
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(30),
        color: Color(0xFFff7050), // Assuming hex color is a constant
        child: MaterialButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Assuming signIn is implemented somewhere
              signIn(emailController.text, passwordController.text);
            }
          },
          minWidth: width,
          child: Text("Login",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

//GoogleSignInButton widget
  Widget buildGoogleSignInButton(BuildContext context, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(FontAwesomeIcons.google, color: Colors.white),
        SizedBox(width: 10),
        Text('Sign in with Google',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ],
    );
  }

//Logo image widget
  Widget buildLogo(double width, double height) {
    return Padding(
      padding: EdgeInsets.only(
          left: width * 0.15,
          right: width * 0.15,
          top: height * 0.02,
          bottom: height * 0.01),
      child: Image.asset('assets/goalPulse.png'),
    );
  }

//Title widget
  Widget buildTitle() {
    return Text("Login",
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFff7050)));
  }

//ResetPasswordLink widget
  Widget buildResetPasswordLink() {
    return GestureDetector(
      onTap: () {
        // Navigate to reset password screen
      },
      child: Text(
        "Forgot password",
        style: TextStyle(
            fontSize: 16,
            color: Colors.blue,
            decoration: TextDecoration.underline),
      ),
    );
  }

  // handling google sign in
  Future handleGoogleSignIn() async {
    print("handleGoogleSignIn");
    final sp = context.read<SignInProvider>();
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();

    if (ip.hasInternet == false) {
      openSnackbar(context, 'Check your Internet connection', Colors.red);
      googleController.reset();
    } else {
      await sp.signInWithGoogle().then((value) {
        if (sp.hasError == true) {
          openSnackbar(context, sp.errorCode.toString(), Colors.white);
          googleController.reset();
        } else {
          // checking whether user exists or not
          sp.checkUserExists().then((value) async {
            if (value == true) {
              // user exists
              await sp.getUserDataFromFirestore(sp.uid).then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            } else {
              // user does not exist
              sp.saveDataToFirestore().then((value) => sp
                  .saveDataToSharedPreferences()
                  .then((value) => sp.setSignIn().then((value) {
                        googleController.success();
                        handleAfterSignIn();
                      })));
            }
          });
        }
      });
    }
    //login function
  }

  //handle After SignIn
  handleAfterSignIn() {
    Future.delayed(const Duration(milliseconds: 1000)).then((value) {
      nextScreenReplace(context, HomeScreen());
    });
  }

  // email password signin function
  void signIn(String email, String password) async {
    User? user = _auth.currentUser;
    final sp = context.read<SignInProvider>();

    if (_formKey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        sp.setSignIn();

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
      }).catchError((e) {
        if (e is FirebaseAuthException && e.code == 'wrong-password') {
        } else {}
      });
    }
  }
}

// Custom Painter for the bottom curved design
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xFFFF7050) // Replace with your desired color
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.5, 1, size.width, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
