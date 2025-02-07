import 'package:flutter/material.dart';
import 'package:matchpoint/services/auth.dart';
import 'package:matchpoint/widgets/main_scaffold.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.read<AppProfileProvider>();
    final authProvider = context.watch<AuthService>();

    return Scaffold(
      body: StreamBuilder(
        stream: authProvider.loginChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final profileFuture =
                profileProvider.loadAndSaveProfile(snapshot.data!.uid);

            return FutureBuilder(
              future: profileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading while async task is processing
                }

                return MainScaffold();
              },
            );
          }
          return _LoginContent();
        },
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent({super.key});

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
            child: _SignInButton(),
          ),
        ],
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.read<AppProfileProvider>();
    final authProvider = context.read<AuthService>();

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            final gUser = authProvider.signInWithGoogle();
            gUser.then(
              (auth) => profileProvider.saveProfileFromUser(auth),
            );
          },
          icon: Image.asset(
            'assets/google_logo.png',
            height: 30,
          ),
          label: Text("Sign in with Google"),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.white),
          ),
        ),
      ],
    );
  }
}
