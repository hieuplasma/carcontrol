import 'dart:convert';

import 'package:control_car/src/resource/components/button_control.dart';
import 'package:flutter/material.dart';

class ControlManual extends StatefulWidget {
  @override
  _ControlManualState createState() => _ControlManualState();
}

class _ControlManualState extends State<ControlManual> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Control Manual"),
      ),
      body: Center(
          child: Container(
        width: 320,
        height: 320,
        child: Row(
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: MyButton(title: "Đi trái", action: 4),
            ),
            Container(
              width: 10,
              height: double.infinity,
            ),
            Container(
              width: 100,
              height: double.infinity,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: MyButton(title: "Đi tiến", action: 2),
                  ),
                  Container(
                    width: 100,
                    height: 120,
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    child: MyButton(title: "Đi lùi", action: 3),
                  )
                ],
              ),
            ),
            Container(
              width: 10,
              height: double.infinity,
            ),
            Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: MyButton(title: "Đi phải", action: 1),
            ),
          ],
        ),
      )),
    );
  }
}
