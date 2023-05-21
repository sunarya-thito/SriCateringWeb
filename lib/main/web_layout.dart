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
        if (width < 540) {
          return widget.builder(context, width);
        }
        if (width <= 576) {
          return widget.builder(context, 540);
        }
        if (width <= 768) {
          return widget.builder(context, 720);
        }
        if (width <= 992) {
          return widget.builder(context, 960);
        }
        if (width <= 1200) {
          return widget.builder(context, 960);
        }
        if (width <= 1440) {
          return widget.builder(context, 1140);
        }
        if (width <= 1680) {
          return widget.builder(context, 1366);
        }
        return widget.builder(context, 1600);
      },
    );
  }
}
