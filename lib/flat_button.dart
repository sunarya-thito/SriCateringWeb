import 'package:flutter/material.dart';
import 'package:sricatering/main/page/home_page.dart';

class FlatButton extends StatefulWidget {
  final Widget child;
  final void Function()? onPressed;
  const FlatButton({Key? key, required this.child, this.onPressed})
      : super(key: key);

  @override
  _FlatButtonState createState() => _FlatButtonState();
}

class _FlatButtonState extends State<FlatButton> {
  bool _isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onPressed == null
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          _isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHover = false;
        });
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: widget.onPressed == null
                ? Colors.transparent
                : _isHover
                    ? kHeaderColor
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.onPressed == null
                  ? Colors.black54
                  : !_isHover
                      ? kHeaderColor
                      : Colors.transparent,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.onPressed == null
                  ? Colors.black54
                  : _isHover
                      ? kBackgroundColor
                      : kHeaderColor,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
