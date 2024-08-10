import 'package:flutter/material.dart';

// This file renders the 4 boxes which are used to change the direction of the snake

class Controls extends StatelessWidget {
  final VoidCallback onUpPressed;
  final VoidCallback onDownPressed;
  final VoidCallback onLeftPressed;
  final VoidCallback onRightPressed;

  Controls({
    Key? key,
    required this.onUpPressed,
    required this.onDownPressed,
    required this.onLeftPressed,
    required this.onRightPressed,
  }) : super(key: key);

  Widget _buildControlBox(String text, VoidCallback onPressed, Color color, double width) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 50,
        color: color,
        child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildControlBox("Up", onUpPressed, Colors.red, 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlBox("Left", onLeftPressed, Colors.green, 50),
              _buildControlBox("Right", onRightPressed, Colors.blue, 50),
            ],
          ),
          _buildControlBox("Down", onDownPressed, Colors.amber, 50),
        ],
      ),
    );
  }
}