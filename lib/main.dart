import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // Import your home_page.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(), // Launch your HomePage widget
    );
  }
}
