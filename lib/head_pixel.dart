import 'package:flutter/material.dart';

class HeadPixel extends StatelessWidget {
  const HeadPixel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}