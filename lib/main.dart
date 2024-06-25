import 'package:flutter/material.dart';
import 'package:hometask_63/views/screens/time_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TimeScreen(),
    );
  }
}
