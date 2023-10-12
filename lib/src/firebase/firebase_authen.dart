import 'dart:convert';
import 'dart:io';

import 'package:control_car/src/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FirAuth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp(String email, String pass, String name, String phone,
      Function onSuccess, Function(String) onRegisterError) {
    var fixmail = email.trim();
    var fixpass = pass.trim();
    _firebaseAuth
        .createUserWithEmailAndPassword(email: fixmail, password: fixpass)
        .then((user) => {
              _createUser(
                  user.user.uid, name, phone, onSuccess, onRegisterError),
              print(user)
            })
        .catchError(
            (onError) => {_onSignUpErr(onError.toString(), onRegisterError)});
  }

  _createUser(String userId, String name, String phone, Function onSuccess,
      Function(String) onRegisterError) {
    var user = {"name": name, "phone": phone};
    var ref = FirebaseDatabase.instance.reference().child("drivers");
    ref
        .child(userId)
        .set(user)
        .then((user) => {
              //success
              onSuccess()
            })
        .catchError(
            (onError) => {onRegisterError("Sign up fail, please try again")});
  }

  void signIn(String email, String pass, Function onSuccess,
      Function(String) onSignInError) {
    var mail = email.trim();
    var password = pass.trim();
    _firebaseAuth
        .signInWithEmailAndPassword(email: mail, password: password)
        .then((user) async {
      print(user);
      print("email nè: " + user.user.email);
      print("uid nè: " + user.user.uid);
      final url = '${Api.baseUrl}${user.user.uid}.json';

      final response = await http
          .get(url, headers: {HttpHeaders.authorizationHeader: Api.secretkey});
      final responseData = json.decode(response.body);

      print(responseData);
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': user.user.uid,
        'userEmail': user.user.email,
        'phone': responseData['phone'],
        'name': responseData['name'],
      });
      prefs.remove(Api.authKey);
      prefs.setString(Api.authKey, userData);
      onSuccess();
    }).catchError(
            (onError) => {_onSignInErr(onError.toString(), onSignInError)});
  }

  void _onSignUpErr(String msg, Function(String) onRegisterError) {
    print(msg);
    onRegisterError(msg);
  }

  void _onSignInErr(String msg, Function(String) onSignInError) {
    print(msg);
    onSignInError(msg);
  }
}
