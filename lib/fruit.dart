import 'package:flutter/material.dart';

// This renders the "fruit" which the snake will eat

class Fruit extends StatelessWidget {
  const Fruit({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Icon(Icons.star, color: Colors.amber, size: 40,)
    );
  }
}