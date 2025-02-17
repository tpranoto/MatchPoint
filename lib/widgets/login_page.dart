import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'main_scaffold.dart';
import 'login_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final authProvider = context.watch<AppAuthProvider>();

    return Scaffold(
      body: StreamBuilder(
        stream: authProvider.stateChanges,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LoginContent();
          }

          return FutureBuilder(
            future: profileProvider.loadProfile(snapshot.data!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CenteredLoading();
              }

              if (snapshot.hasError) {
                //TODO
              }

              return MainScaffold();
            },
          );
        },
      ),
    );
  }
}
