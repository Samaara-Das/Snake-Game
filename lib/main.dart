import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBMokBP5Fr6bxPF2oADzxQUvsW2WbbfHUU",
      authDomain: "snakegame-a1bc3.firebaseapp.com",
      projectId: "snakegame-a1bc3",
      storageBucket: "snakegame-a1bc3.appspot.com",
      messagingSenderId: "747081055416",
      appId: "1:747081055416:web:68b5087cc8c5026d65c84d",
      measurementId: "G-YQCV6ZL453"
    )
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark),
      home: HomePage(),
    );
  }
}
