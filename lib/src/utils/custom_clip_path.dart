import 'package:flutter/material.dart';

class AppBarClipPath extends CustomClipper<Path> {
  AppBarClipPath({required this.context, required this.height});

  final BuildContext context;
  final double height;

  @override
  Path getClip(Size size) {
    // print(size);
    // double w = size.width;
    // double h = size.height;

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    final path = Path();

    // path.moveTo(0, 0);
    // path.lineTo(w * 0.5, h * 0.0);
    // path.lineTo(w * 0.85, h * 0.12);
    // path.lineTo(w, h * 0.12);

    path.moveTo(0, 0);
    path.lineTo(0, h * height);
    path.lineTo(w, h * height);
    // path.quadraticBezierTo(w * 0.1, h * 0.12, w * 0.5, h * 0.08);
    // path.quadraticBezierTo(w * 0.8, h * 0.05, w, h * 0.11);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ChatBoxClipPath extends CustomClipper<Path> {
  ChatBoxClipPath({required this.context, required this.height});

  final BuildContext context;
  final double height;

  @override
  Path getClip(Size size) {
    double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;

    final path = Path();

    path.moveTo(0, 0);
    path.lineTo(0, height);
    path.lineTo(w, height);

    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
