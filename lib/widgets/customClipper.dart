
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ClipPainter extends CustomClipper<Path>{
  @override
 
  //  Path getClip(Size size) {
  //     var height = size.height;
  //   var width = size.width;
  //   var path = new Path();
  //
  //   path.lineTo(0, size.height );
  //   path.lineTo(size.width , height);
  //   path.lineTo(size.width , 0);
  //
  //    /// [Top Left corner]
  //   var secondControlPoint =  Offset(0  ,0);
  //   var secondEndPoint = Offset(width * .2  , height *.3);
  //   path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
  //
  //
  //
  //    /// [Left Middle]
  //   var fifthControlPoint =  Offset(width * .3  ,height * .5);
  //   var fiftEndPoint = Offset(  width * .23, height *.6);
  //   path.quadraticBezierTo(fifthControlPoint.dx, fifthControlPoint.dy, fiftEndPoint.dx, fiftEndPoint.dy);
  //
  //
  //    /// [Bottom Left corner]
  //   var thirdControlPoint =  Offset(0  ,height);
  //   var thirdEndPoint = Offset(width , height  );
  //   path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy, thirdEndPoint.dx, thirdEndPoint.dy);
  //
  //
  //
  //   path.lineTo(0, size.height  );
  //   path.close();
  //
  //   return path;
  // }

  // Path getClip(Size size) {
  //
  //   var path = new Path();
  //   path.lineTo(0, size.height); //start path with this if you are making at bottom
  //
  //   var firstStart = Offset(size.width / 5, size.height);
  //   //fist point of quadratic bezier curve
  //   var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
  //   //second point of quadratic bezier curve
  //   path.quadraticBezierTo(firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);
  //
  //   var secondStart = Offset(size.width - (size.width / 3.24), size.height - 105);
  //   //third point of quadratic bezier curve
  //   var secondEnd = Offset(size.width, size.height - 10);
  //   //fourth point of quadratic bezier curve
  //   path.quadraticBezierTo(secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);
  //
  //   path.lineTo(size.width, 0); //end with this path if you are making wave at bottom
  //   path.close();
  //   return path;
  // }

  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height - 80, size.width / 2, size.height - 40);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

  
}