import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';


class MyButton extends StatefulWidget {
  @override
  _MyButtonState createState() => _MyButtonState();
  MyButton({Key key,this.title, this.action}) : super(key: key);
  int action;
  String title;
}


class _MyButtonState extends  State<MyButton> {

  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
    // The GestureDetector wraps the button.
    return GestureDetector(
      // When the child is tapped, send action to server.
    onTapDown: (TapDownDetails details){
      var ref = FirebaseDatabase.instance.reference().child("data");
      ref.update({
      'action': widget.action
      });
      setState(() {
        _hasBeenPressed = true;
      });
      },
      onTapUp: (TapUpDetails details){
        var ref = FirebaseDatabase.instance.reference().child("data");
        ref.update({
          'action': 0
        });
        setState(() {
          _hasBeenPressed = false;
        });
      },
      // The custom button
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color:_hasBeenPressed? Colors.yellow: Colors.green,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(widget.title,  style: TextStyle( color: Colors.white, fontWeight: FontWeight.bold)) ,
      ),
    );
  }
}