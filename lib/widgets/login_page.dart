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
            'assets/google_logo.png', // Make sure to add the Google logo to your assets
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
