import 'package:flutter/material.dart';
import 'dart:async';

class StartPopup extends StatefulWidget {
  const StartPopup({super.key});

  @override
  State<StartPopup> createState() => _StartPopupState();
}

class _StartPopupState extends State<StartPopup> {
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      setState(() {
        isVisible = !isVisible;
      });
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: Container(
        width: 200,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle
        ),
        child: const Text('Click an arrow to start', style: TextStyle(fontSize: 24, color: Colors.amber),),
      )
    );
  }
}

