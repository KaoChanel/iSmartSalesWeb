import 'dart:math';
import 'package:flutter/material.dart';
import 'customClipper.dart';

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: 0,
        child: ClipPath(
        clipper: ClipPainter(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF5D62C0), Color(0xFF323682)]
                // colors: [Color(0xfffbb448), Color(0xffe46b10)]
              )
            ),
        ),
      ),
      )
    );
  }
}