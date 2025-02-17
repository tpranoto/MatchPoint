import 'package:flutter/material.dart';

void errorDialog(BuildContext ctx, String text) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Error',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  });
}
