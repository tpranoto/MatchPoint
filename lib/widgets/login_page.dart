import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/widgets/home_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          }
          return _loginPageContent();
        },
      ),
    );
  }

  Widget _loginPageContent() {
    return Center(
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Image(
              image: AssetImage("assets/matchpoint.png"),
              width: 100,
              height: 100,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Match Point",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Expanded(
            flex: 3,
            child: _signInButton(),
          ),
        ],
      ),
    );
  }

  Widget _signInButton() {
    return Column(
      children: [
        SignInButton(
          Buttons.Google,
          onPressed: () {
            AuthService().signInWithGoogle();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: BorderSide(
              color: const Color(
                0x80808080,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
