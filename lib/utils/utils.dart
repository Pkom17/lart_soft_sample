import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  Utils._(); // Private constructor to prevent instantiation

  static bool validatePassword(String password, String passwordErrorMessage) {
    passwordErrorMessage = '';

    if (password.length < 7) {
      passwordErrorMessage +=
          '• Mot de passe doit contenir au moins 7 caractères \n';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      passwordErrorMessage +=
          '• Mot de passe doit contenir au moins une lettre majuscule.\n';
    }

    if (!password.contains(RegExp(r'[a-z]'))) {
      passwordErrorMessage +=
          '• Mot de passe doit contenir au moins une lettre minuscule.\n';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      passwordErrorMessage +=
          '• Mot de passe doit contenir au moins un chiffre.\n';
    }

    if (!password.contains(RegExp(r'[!@#%^&*_(),.?":{}|<>]'))) {
      passwordErrorMessage +=
          '• Mot de passe doit contenir au moins un caractère spécial.\n';
    }

    return passwordErrorMessage.isEmpty;
  }

  static showAlertDialog(BuildContext context, String message) async {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Message"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> saveData(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String?> getData(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green.shade400,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red.shade300,
      behavior: SnackBarBehavior.floating,
    ));
  }
}
