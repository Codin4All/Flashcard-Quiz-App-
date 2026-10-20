
import 'package:flutter/material.dart';
import 'screens/flashcard_screen.dart';

void main() {
  runApp(const FlashcardApp());
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcard Quiz',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6558F5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
      ),
      home: const FlashcardScreen(),
    );
  }
}
