import 'package:flutter/material.dart';
import 'snake_game_page.dart';
import 'game_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => GameProvider(columns: 10, rows: 10),
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const SnakeGamePage(title: 'Snake Game'),
    );
  }
}

