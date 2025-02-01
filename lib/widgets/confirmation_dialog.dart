import 'package:flutter/material.dart';

void showConfirmationDialog(
  BuildContext context,
  String action,
  Function callback,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(action),
        content: Text('Are you sure you want to ${action.toLowerCase()}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              callback();
              Navigator.of(context).pop();
            },
            child: Text("Confirm"),
          ),
        ],
      );
    },
  );
}
