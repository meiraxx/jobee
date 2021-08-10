import 'package:flutter/material.dart';
import 'package:jobee/services/service00_authentication/0.0_auth.dart' show AuthService;
import 'package:jobee/screens/widgets/dialogs/confirmation_dialog.dart' show showConfirmationDialog;

/// Logout user when user confirms he wants to logout
Future<void> handleLogout(BuildContext context) async {
  final bool? signOutChoice = await showConfirmationDialog(
    context,
    "Are you sure you want to logout?",
    "No, keep me signed in",
    "Yes, sign me out",
  );
  if (signOutChoice == null || signOutChoice == false) return;

  // else, user wants to sign out
  await AuthService.signOut();
}