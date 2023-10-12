import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class Auth with ChangeNotifier {
  var AuthKey = Api.authKey;

  String _userId;
  String _userEmail;
  String _phone;
  String _name;

  bool get isAuth {
    return _userId != null;
  }



  String get userId {
    return _userId;
  }

  String get userEmail {
    return _userEmail;
  }

  String get phone {
    return _phone;
  }

  String get name {
    return _name;
  }

  Future<void> logout() async {
    _userEmail = null;
    _userId = null;
    _phone = null;
    _name = null;

    notifyListeners();

    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<bool> tryautoLogin() async {
    final pref = await SharedPreferences.getInstance();

    final extractedUserData =
    json.decode(pref.getString(AuthKey)) as Map<String, Object>;

    _userId = extractedUserData['userId'];
    _userEmail = extractedUserData['userEmail'];
    _phone = extractedUserData['phone'];
    _name = extractedUserData['name'];
    notifyListeners();
    return true;
  }
}
