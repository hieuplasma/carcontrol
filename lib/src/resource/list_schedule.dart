import 'package:control_car/src/resource/dialog/confirm_dialog.dart';
import 'package:control_car/src/utils/constants.dart';
import 'package:control_car/src/utils/entity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'dart:convert';

import 'control_schedule.dart';

class ListSchedule extends StatefulWidget {
  @override
  _ListScheduleState createState() => _ListScheduleState();
}

class _ListScheduleState extends State<ListSchedule> {
  List<dynamic> list = [];

  _setupList() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(prefs.getString(Api.authKey)) as Map<String, Object>;
    print(extractedUserData);
    Query needsSnapshot = await FirebaseDatabase.instance
        .reference()
        .child("drivers")
        .child("${extractedUserData['userId']}")
        .child("ways");
    print(needsSnapshot);
    needsSnapshot.once().then((DataSnapshot snapshot) {
      setState(() {
        print(snapshot.value);
        list = snapshot.value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _setupList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('List Schedule'),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: (list == null)
              ? Text("Người dùng chưa có lịch sử chạy xe")
              : Container(
                  child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return (list[index] == null)
                            ? Container( width: 0, height: 0,)
                        :Container(
                          margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                              boxShadow: [
                                BoxShadow(color: Colors.green, spreadRadius: 1)
                              ]),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "ID: $index",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Độ dài quãng đường: ${list[index]["pattern"].length}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Thời điểm chạy: ${DateFormat('yyyy-MM-dd – kk:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(list[index]["timestamp"]))}",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: 200,
                                      height: 40,
                                      margin:
                                          EdgeInsets.only(left: 120, top: 10),
                                      alignment: Alignment.center,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.center,
                                            width: 100,
                                            child: RaisedButton(
                                              onPressed: () => goSchedule(),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                "Chi tiết",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green),
                                              ),
                                              color: Colors.white,
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 100,
                                            child: RaisedButton(
                                              onPressed: () => _delete(index),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                "Xóa",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green),
                                              ),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
        ));
  }

  void goSchedule() {
    //Khai báo một thuộc tính static của lớp nào đó
    //và trong hàm build giao diện thì truy cập đến biến static đó
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => new ControlSchedule()));
    var ref = FirebaseDatabase.instance.reference().child("data");
    ref.update({'type': "stop"});
  }

  void _delete(int index) {
    print("Xóa $index");
    ConFirmDalog.showMsgDialog(context, "Xóa đường chạy",
        "Bạn muốn xóa đường chạy?", () => delete(index));
  }

  Future<void> delete(int index) async {
    final pref = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(pref.getString(Api.authKey)) as Map<String, Object>;
    var _userId = extractedUserData['userId'];
    var ref = FirebaseDatabase.instance
        .reference()
        .child("drivers")
        .child("$_userId")
        .child("ways");
    ref.child("$index").remove().then((value) => _setupList());
  }
}
