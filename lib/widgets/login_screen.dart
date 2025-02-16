import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import 'common.dart';

class LoginContent extends StatelessWidget {
  const LoginContent({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: _GoogleSignInButton(),
          ),
        ],
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton();

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.read<ProfileProvider>();
    final authProvider = context.read<AppAuthProvider>();

    return Column(
      children: [
        SquaredButton(
          onPressed: () async {
            await authProvider.signInWithGoogle();
            await profileProvider.loadAndSaveProfile(authProvider.getData);
          },
          icon: Image.asset(
            'assets/google_logo.png',
            height: 30,
          ),
          text: "Sign in with Google",
        ),
      ],
    );
  }
}
