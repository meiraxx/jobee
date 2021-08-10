import 'package:flutter/material.dart';

/// Show a confirmation dialog
Future<bool?> showConfirmationDialog(BuildContext context, String question, String declineResponse, String acceptResponse) async {
  bool? choice;

  // show the dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Action confirmation"),
        content: Text(question),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              choice = false;
              Navigator.pop(context);
            },
            child: Text(declineResponse),
          ),
          TextButton(
            onPressed: () async {
              choice = true;
              Navigator.pop(context);
            },
            child: Text(acceptResponse),
          ),
        ],
      );
    },
  );

  return choice;
}