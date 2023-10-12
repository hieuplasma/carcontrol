import 'package:firebase_database/firebase_database.dart';

class User {
  String name;
  String phone;
  String uid;

  User();

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phone = json['phone'],
        uid = json['z'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'uid': uid,
  };
}


class MyWay {
  final String id;
  final String description;
  final int start;
  final double timestamp;

  MyWay({
    this.id,
    this.description,
    this.start,
    this.timestamp,
  });

  MyWay.fromSnapshot(DataSnapshot snapshot) :
        id = snapshot.key,
        description = snapshot.value["description"],
        start = snapshot.value["start"],
        timestamp = snapshot.value["timestamp"];

  toJson() {
    return {
      "description": description,
      "start": start,
      "timestamp": timestamp,
    };
  }
}


