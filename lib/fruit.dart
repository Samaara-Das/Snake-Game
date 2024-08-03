import 'package:flutter/material.dart';

class Fruit extends StatelessWidget {
  const Fruit({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Icon(Icons.star, color: Colors.amber,)
    );
  }
}