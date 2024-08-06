import 'package:flutter/material.dart';

class Controls extends StatelessWidget {
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;

  const Controls({
    Key? key,
    required this.onUpPressed,
    required this.onDownPressed,
    required this.onLeftPressed,
    required this.onRightPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_drop_up),
              iconSize: 40,
              onPressed: onUpPressed,
            ),
          ),
          Positioned(
            bottom: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 40,
              onPressed: onDownPressed,
            ),
          ),
          Positioned(
            left: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_left),
              iconSize: 40,
              onPressed: onLeftPressed,
            ),
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_right),
              iconSize: 40,
              onPressed: onRightPressed,
            ),
          ),
        ],
      ),
    );
  }
}