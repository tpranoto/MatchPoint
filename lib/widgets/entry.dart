import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common.dart';
import 'login_page.dart';
import 'main_scaffold.dart';
import '../providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class Entry extends StatelessWidget {
  const Entry({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final authProvider = context.watch<AppAuthProvider>();

    return MPStreamBuilder(
      stream: authProvider.stateChanges,
      streamContinuation: () {},
      onSuccess: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoginPage();
        }

        return MPFutureBuilder(
          future: profileProvider.loadProfile(snapshot.data!.uid),
          onSuccess: (context, snapshot) {
            if (snapshot.hasError) {
              errorDialog(context, "${snapshot.error}");
              return LoginPage();
            }

            if (!snapshot.hasData) {}

            return MainScaffold();
          },
        );
      },
    );
  }
}
