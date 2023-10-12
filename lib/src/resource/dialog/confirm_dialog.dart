import 'package:flutter/material.dart';

class ConFirmDalog {
  static void showMsgDialog(
      BuildContext context, String title, String msg, Function onPressOk) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          new FlatButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(ConFirmDalog);
            },
          ),
          new FlatButton(
            child: Text("OK"),
            onPressed: () {
              onPressOk();
              Navigator.of(context).pop(ConFirmDalog);
            },
          ),
        ],
      ),
    );
  }
}
