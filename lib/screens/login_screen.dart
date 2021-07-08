import 'package:flash_chat_flutter/components/roundedButton.dart';
import 'package:flash_chat_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool showSpinner = false;
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  late AnimationController controller;
  late Animation logoAnimation;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    logoAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutSine);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Container(
                  height: logoAnimation.value * 200,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Flexible(
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter your email',
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Flexible(
                child: TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    labelText: 'Enter your password',
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: 'Log in',
                colour: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    Navigator.pushNamed(context, ChatScreen.id);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("The password provided is wrong."),
                        backgroundColor: Colors.blue,
                        action: SnackBarAction(
                          label: 'Ok',
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ));
                      print('The password provided is wrong.');
                    } else if (e.code == "user-not-found") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("No user found for that email."),
                        backgroundColor: Colors.blue,
                        action: SnackBarAction(
                          label: 'Ok',
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ));
                      print('No user found for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                  setState(() {
                    showSpinner = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
