import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/widgets/main_scaffold.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.read<AppProfileProvider>();
    return Scaffold(
      body: StreamBuilder(
        stream: AuthService().loginChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            profileProvider.loadAndSaveProfile(snapshot.data!.uid);
            return MainScaffold();
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

  Widget _signInButton(BuildContext context) {
    final profileProvider = context.read<AppProfileProvider>();
    return Column(
      children: [
        SignInButton(
          Buttons.Google,
          onPressed: () {
            profileProvider.signInAndSaveProfile();
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
