import 'dart:convert';

import 'package:control_car/src/resource/dialog/run_dialog.dart';
import 'package:control_car/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/draw_way.dart';
import 'components/utils_pattern.dart';
import 'dialog/mess_dialog.dart';

class ControlSchedule extends StatefulWidget {
  static _ControlScheduleState of(BuildContext context) =>
      context.findAncestorStateOfType<_ControlScheduleState>();

  final int dimension;
  final double relativePadding;
  final Color selectedColor;
  final Color notSelectedColor;
  final double pointRadius;
  final bool showInput;
  final int selectThreshold;
  final bool fillPoints;

  // final Function(List<int>) onInputComplete;
  // final Function(String) onWayComplete;

  const ControlSchedule({
    Key key,

    this.dimension = 7,
    this.relativePadding = 0.7,
    this.selectedColor = Colors.red, // Theme.of(context).primaryColor if null
    this.notSelectedColor = Colors.black45,
    this.pointRadius = 4,
    this.showInput = true,
    this.selectThreshold = 25,
    this.fillPoints = true,

    // @required this.onInputComplete,
    // @required this.onWayComplete,
  })  : assert(dimension != null),
        assert(relativePadding != null),
        assert(pointRadius != null),
        assert(showInput != null),
        assert(selectThreshold != null),
        assert(fillPoints != null),
        // assert(onInputComplete != null),
        // assert(onWayComplete != null),
        super(key: key);

  @override
  _ControlScheduleState createState() => _ControlScheduleState();
}

class _ControlScheduleState extends State<ControlSchedule> {
  List<int> pattern = [];
  String way = '';
  Offset currentPoint;
  Offset fakePoint;


  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Draw Line'),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Text(
              "Draw your Schedule!",
              style: TextStyle(
                  color: Color(0xff3277D8),
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: double.infinity,
            height: 400,
            color: Colors.white,
            child: GestureDetector(
              onPanEnd: (DragEndDetails details) {
                if (pattern.isNotEmpty) {
                  print("pattern is $pattern");
                  print("way is $way");
                }
              },
              onPanUpdate: (DragUpdateDetails details) {
                RenderBox referenceBox = context.findRenderObject();
                Offset localPosition =
                    referenceBox.globalToLocal(details.globalPosition);
                Offset fakelocal =
                    referenceBox.globalToLocal(details.localPosition);
                Offset circlePosition(int n) => calcCirclePosition(
                      n,
                      referenceBox.size,
                      widget.dimension,
                      widget.relativePadding,
                    );

                print(localPosition);
                setState(() {
                  currentPoint = localPosition;
                  fakePoint = fakelocal;
                  for (int i = 0;
                      i < widget.dimension * widget.dimension;
                      ++i) {
                    final toPoint =
                        (circlePosition(i) - localPosition).distance;
                    var oldPoint = 0;
                    if (pattern.isEmpty) {
                      oldPoint = i;
                    } else {
                      oldPoint = pattern[pattern.length - 1];
                    }
                    var check = 0;
                    switch (i - oldPoint) {
                      case 0:
                        {
                          check = 5;
                          // statements;
                        }
                        break;
                      case 1:
                        {
                          check = 6;
                        }
                        break;
                      case -1:
                        {
                          check = 4;
                        }
                        break;
                      case -7:
                        {
                          check = 2;
                        }
                        break;
                      case -8:
                        {
                          check = 1;
                        }
                        break;
                      case -6:
                        {
                          check = 3;
                        }
                        break;
                      case 6:
                        {
                          check = 7;
                        }
                        break;
                      case 7:
                        {
                          check = 8;
                        }
                        break;
                      case 8:
                        {
                          check = 9;
                        }
                        break;

                      default:
                        {
                          //statements;
                        }
                    }
                    if (!pattern.contains(i) &&
                        toPoint < widget.selectThreshold &&
                        check != 0) {
                      pattern.add(i);
                      way = way + '$check';
                    }
                  }
                });
              },
              child: CustomPaint(
                painter: _LockPainter(
                  dimension: widget.dimension,
                  pattern: pattern,
                  currentPoint: currentPoint,
                  fakePoint: fakePoint,
                  relativePadding: widget.relativePadding,
                  selectedColor:
                      widget.selectedColor ?? Theme.of(context).primaryColor,
                  notSelectedColor: widget.notSelectedColor,
                  pointRadius: widget.pointRadius,
                  showInput: widget.showInput,
                  fillPoints: widget.fillPoints,
                ),
                size: Size.infinite,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 20,
            height: 1,
            color: Colors.grey,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
          ),
          Container(
            width: double.infinity,
            height: 100,
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  child: RaisedButton(
                    onPressed: () => _resetSchedule(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("Reset Schedule"),
                    color: Colors.green,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  child: RaisedButton(
                    onPressed: () => pattern.length == 0 ? {} : _runSchedule(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("Run Schedule"),
                    color: pattern.length == 0 ? Colors.grey : Colors.green,
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  void _resetSchedule() {
    setState(() {
      pattern = [];
      currentPoint = null;
      way = '';
    });
  }

  void _runSchedule() async {
    final pref = await SharedPreferences.getInstance();
    final extractedUserData =
        json.decode(pref.getString(Api.authKey)) as Map<String, Object>;
    var _userId = extractedUserData['userId'];
    var ref = FirebaseDatabase.instance.reference().child("data");
    ref.update({'schedule': way, 'type': 'schedule'});
    String ack = "";
    while (ack=="schedule")
    {
      ref.child("type").once().then((value) => ack = value.value);
    }
    RunDialog.showRunDialog(context, "RUNNING", "Xe đang thực hiện lộ trình", ()=> {});

    var ref1 = FirebaseDatabase.instance
        .reference()
        .child("drivers")
        .child("$_userId");
    ref1.child("ways").once().then((value) => {
          if (value.value == null)
            {
              ref1.child("ways").child("0").set({
                'start': pattern[0],
                'description': way,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
                'pattern': pattern,
              })
            }
          else
            {
              ref1.child("ways").child("${value.value.length}").set({
                'start': pattern[0],
                'description': way,
                'timestamp': DateTime.now().millisecondsSinceEpoch,
                'pattern': pattern,
              })
            }
        });
  }
}

@immutable
class _LockPainter extends CustomPainter {
  final int dimension;
  final List<int> pattern;
  final Offset currentPoint;
  final Offset fakePoint;
  final double relativePadding;
  final Color selectedColor;
  final Color notSelectedColor;
  final double pointRadius;
  final bool showInput;
  final bool fillPoints;

  final Paint circlePaint;
  final Paint selectedPaint;

  _LockPainter({
    this.dimension,
    this.pattern,
    this.currentPoint,
    this.fakePoint,
    this.relativePadding,
    this.selectedColor,
    this.notSelectedColor,
    this.pointRadius,
    this.showInput,
    this.fillPoints,
  })  : circlePaint = Paint()
          ..color = notSelectedColor
          ..style = fillPoints ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = 2,
        selectedPaint = Paint()
          ..color = selectedColor
          ..style = fillPoints ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2;

  @override
  void paint(Canvas canvas, Size size) {
    Offset circlePosition(int n) =>
        calcCirclePosition(n, size, dimension, relativePadding);

    for (int i = 0; i < dimension; ++i) {
      for (int j = 0; j < dimension; ++j) {
        canvas.drawCircle(
          circlePosition(i * dimension + j),
          pointRadius,
          showInput && pattern.contains(i * dimension + j)
              ? selectedPaint
              : circlePaint,
        );
      }
    }

    if (showInput) {
      for (int i = 0; i < pattern.length - 1; ++i) {
        canvas.drawLine(
          circlePosition(pattern[i]),
          circlePosition(pattern[i + 1]),
          selectedPaint,
        );
      }

      if (pattern.isNotEmpty && currentPoint != null) {
        canvas.drawLine(
          circlePosition(pattern[pattern.length - 1]),
          fakePoint,
          selectedPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
