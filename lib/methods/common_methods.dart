import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CommonMethods {
  checkConnectivity(BuildContext context) async {
    var conectionResult = await Connectivity().checkConnectivity();
    if (conectionResult != ConnectivityResult.mobile &&
        conectionResult != ConnectivityResult.wifi) {
      if (!context.mounted) {
        displaySnackbar(
            'You are not connected to the internet. Please try again', context);
      }
    }
  }

  displaySnackbar(String messageText, BuildContext context) {
    var snackbar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
