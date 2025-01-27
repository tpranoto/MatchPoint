import 'package:flutter/material.dart';

import '../services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Home"),
      ),
      body: Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AuthService().signOut();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
