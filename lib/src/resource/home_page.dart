import 'dart:convert';

import 'package:control_car/src/resource/components/button_control.dart';
import 'package:control_car/src/resource/control_manual.dart';
import 'package:control_car/src/resource/control_schedule.dart';
import 'package:control_car/src/resource/dialog/confirm_dialog.dart';
import 'package:control_car/src/resource/list_schedule.dart';
import 'package:control_car/src/resource/login_page.dart';
import 'package:control_car/src/utils/constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(

        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed:  ()=> ConFirmDalog.showMsgDialog(context, "Logout", "You want logout?",()=> onLogout(), ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Text("Logout"),
              color: Colors.green,
            ),
            RaisedButton(
              onPressed:()=> goManual(),
              padding:const EdgeInsets.fromLTRB(10, 10, 10, 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Text("Direct Controls"),
              color: Colors.yellow,
            ),
            RaisedButton(
              onPressed:()=> goSchedule(),
              padding:const EdgeInsets.fromLTRB(10, 10, 10, 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Text("Schedule Controls"),
              color: Colors.yellow,
            ),
            RaisedButton(
              onPressed:()=> goHistory(),
              padding:const EdgeInsets.fromLTRB(10, 10, 10, 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Text("Lịch sử đường chạy"),
              color: Colors.yellow,
            ),
            RaisedButton(
              onPressed:()=> goDisconnect(),
              padding:const EdgeInsets.fromLTRB(10, 10, 10, 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Text("Disconnect"),
              color: Colors.yellow,
            ),
          ],
        )

      ),
    );
  }


  void onLogout () async{
    final pref = await SharedPreferences.getInstance();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> new LoginPage()));
    pref.remove(Api.authKey);
  }


  void goManual () {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> new ControlManual()));
    var ref = FirebaseDatabase.instance.reference().child("data");
    ref.update({'type': "manual"});
  }

  void goSchedule () {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> new ControlSchedule()));
    var ref = FirebaseDatabase.instance.reference().child("data");
    ref.update({'type': "stop"});
  }

  void goHistory () {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> new ListSchedule()));
    var ref = FirebaseDatabase.instance.reference().child("data");
    ref.update({'type': "stop"});
  }

  void goDisconnect () {
    var ref = FirebaseDatabase.instance.reference().child("data");
    ref.update({'ack': "false" });
  }
}
