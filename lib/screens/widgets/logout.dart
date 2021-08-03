import 'package:flutter/material.dart';
import 'package:jobee/services/service00_authentication/0.0_auth.dart' show AuthService;

/// Logout user when user confirms he wants to logout
Future<void> handleLogout(BuildContext context) async {
  final bool? signOutChoice = await _showBoolAlertDialog(context);
  if (signOutChoice == null || signOutChoice == false) return;

  // else, user wants to sign out
  await AuthService.signOut();
}

/// Show confirmation box for logout
Future<bool?> _showBoolAlertDialog(BuildContext context) async {
  bool? signOutChoice;

  // show the dialog
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Action confirmation"),
        content: const Text("Are you sure you want to logout?"),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              signOutChoice = false;
              Navigator.pop(context);
            },
            child: const Text("No, keep me signed in"),
          ),
          TextButton(
            onPressed: () async {
              signOutChoice = true;
              Navigator.pop(context);
            },
            child: const Text("Yes, sign me out"),
          ),
        ],
      );
    },
  );

  return signOutChoice;
}