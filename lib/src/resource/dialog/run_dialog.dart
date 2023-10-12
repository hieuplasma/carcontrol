import 'package:flutter/material.dart';

class RunDialog {
  static void showRunDialog(
      BuildContext context, String title, String msg, Function onPressCancle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          new FlatButton(
            child: Text("OK"),
            onPressed: () {
              onPressCancle();
              Navigator.of(context).pop(RunDialog());
            },
          ),
        ],
      ),
    );
  }

  static void disRunDialog(BuildContext context) {
    Navigator.of(context).pop(RunDialog());
  }
}
