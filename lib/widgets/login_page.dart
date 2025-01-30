import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:matchpoint/models/profile.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/widgets/home_screen.dart';
import 'package:matchpoint/widgets/main_scaffold.dart';
import 'package:provider/provider.dart';

import '../services/firestore.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder(
              future: FirestoreService().getById(snapshot.data!.uid),
              builder: (context, profileSnapshot) {
                if (profileSnapshot.hasData) {
                  final storedProfile = profileSnapshot.data;
                  final profileProvider = context.watch<AppProfileProvider>();
                  profileProvider.saveProfile(storedProfile);
                }
                return MainScaffold();
              },
            );
          }
          return _loginPageContent(context);
        },
      ),
    );
  }

  Widget _loginPageContent(BuildContext context) {
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
            child: _signInButton(context),
          ),
        ],
      ),
    );
  }

  _onPressedSignIn(AppProfileProvider profileProvider) {
    final Future<User?> gUser = AuthService().signInWithGoogle();
    gUser.then((gUserDt) {
      if (gUserDt != null) {
        final appProfile =
            FirestoreService().addProfileIfNotExists(Profile.fromUser(gUserDt));
        if (appProfile != null) {
          profileProvider.saveProfile(appProfile);
        }
      }
    });
  }

  Widget _signInButton(BuildContext context) {
    final profileProvider = context.read<AppProfileProvider>();
    return Column(
      children: [
        SignInButton(
          Buttons.Google,
          onPressed: () {
            _onPressedSignIn(profileProvider);
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
