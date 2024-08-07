import 'package:flutter/material.dart';

class Controls extends StatelessWidget {
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;
  double iconSize;

  Controls({
    Key? key,
    required this.onUpPressed,
    required this.onDownPressed,
    required this.onLeftPressed,
    required this.onRightPressed,
    this.iconSize = 50
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_drop_up),
              iconSize: iconSize,
              onPressed: onUpPressed,
            ),
          ),
          Positioned(
            bottom: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_drop_down),
              iconSize: iconSize,
              onPressed: onDownPressed,
            ),
          ),
          Positioned(
            left: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_left),
              iconSize: iconSize,
              onPressed: onLeftPressed,
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_right),
              iconSize: iconSize,
              onPressed: onRightPressed,
            ),
          ),
        ],
      ),
    );
  }
}