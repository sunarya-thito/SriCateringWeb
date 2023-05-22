import 'package:flutter/material.dart';

class WebLayout extends StatefulWidget {
  final Function(BuildContext context, double width) builder;
  const WebLayout({Key? key, required this.builder}) : super(key: key);

  @override
  _WebLayoutState createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        if (width > 992) {
          width = 992;
        } else if (width > 768) {
          width = 768;
        } else if (width > 576) {
          width = 576;
        }
        width = width - 48;
        return widget.builder(context, width);
      },
    );
  }
}
