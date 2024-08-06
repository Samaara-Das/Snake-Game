import 'package:flutter/material.dart';

class SnakeBody extends StatelessWidget {
  const SnakeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.indigoAccent,
      ),
    );
  }
}

class Head extends StatelessWidget {
  const Head({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.blue,
      ),
    );
  }
}
