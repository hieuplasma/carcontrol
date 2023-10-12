import 'package:control_car/src/resource/components/utils_pattern.dart';
import 'package:flutter/material.dart';

class MyPatternLock extends StatefulWidget {
  static _PatternLockState of(BuildContext context) =>
      context.findAncestorStateOfType<_PatternLockState>();

  final int dimension;
  final double relativePadding;
  final Color selectedColor;
  final Color notSelectedColor;
  final double pointRadius;
  final bool showInput;
  final int selectThreshold;
  final bool fillPoints;
  final Function(List<int>) onInputComplete;
  final Function(String) onWayComplete;

  const MyPatternLock({
    Key key,
    this.dimension = 3,
    this.relativePadding = 0.7,
    this.selectedColor, // Theme.of(context).primaryColor if null
    this.notSelectedColor,
    this.pointRadius = 10,
    this.showInput = true,
    this.selectThreshold = 25,
    this.fillPoints = false,
    @required this.onInputComplete,
    @required this.onWayComplete,
  })  : assert(dimension != null),
        assert(relativePadding != null),
        assert(pointRadius != null),
        assert(showInput != null),
        assert(selectThreshold != null),
        assert(fillPoints != null),
        assert(onInputComplete != null),
        assert(onWayComplete != null),
        super(key: key);

  @override
  _PatternLockState createState() => _PatternLockState();
}

class _PatternLockState extends State<MyPatternLock> {
  List<int> used = [];
  String way = '';
  Offset currentPoint;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (DragEndDetails details) {
        if (used.isNotEmpty) {
          widget.onInputComplete(used);
          widget.onWayComplete(way);
        }
        setState(() {});
      },
      onPanUpdate: (DragUpdateDetails details) {
        RenderBox referenceBox = context.findRenderObject();
        Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);

        Offset circlePosition(int n) => calcCirclePosition(
              n,
              referenceBox.size,
              widget.dimension,
              widget.relativePadding,
            );

        setState(() {
          currentPoint = localPosition;
          for (int i = 0; i < widget.dimension * widget.dimension; ++i) {
            final toPoint = (circlePosition(i) - localPosition).distance;
            var oldPoint = 0;
            if (used.isEmpty) {
              oldPoint = i;
            } else {
              oldPoint = used[used.length - 1];
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
                  check = 8;
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
            if (!used.contains(i) &&
                toPoint < widget.selectThreshold &&
                check != 0 ) {
              used.add(i);
              way = way + '$check';
            }
          }
        });
      },
      child: CustomPaint(
        painter: _LockPainter(
          dimension: widget.dimension,
          used: used,
          currentPoint: currentPoint,
          relativePadding: widget.relativePadding,
          selectedColor: widget.selectedColor ?? Theme.of(context).primaryColor,
          notSelectedColor: widget.notSelectedColor ?? Colors.black45,
          pointRadius: widget.pointRadius,
          showInput: widget.showInput,
          fillPoints: widget.fillPoints,
        ),
        size: Size.infinite,
      ),
    );
  }
}

@immutable
class _LockPainter extends CustomPainter {
  final int dimension;
  final List<int> used;
  final Offset currentPoint;
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
    this.used,
    this.currentPoint,
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
          showInput && used.contains(i * dimension + j)
              ? selectedPaint
              : circlePaint,
        );
      }
    }

    if (showInput) {
      for (int i = 0; i < used.length - 1; ++i) {
        canvas.drawLine(
          circlePosition(used[i]),
          circlePosition(used[i + 1]),
          selectedPaint,
        );
      }

      if (used.isNotEmpty && currentPoint != null) {
        canvas.drawLine(
          circlePosition(used[used.length - 1]),
          currentPoint,
          selectedPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
