
import 'package:flutter/material.dart';
import 'package:task_1/model/flashcard.dart';


class FlashcardCard extends StatelessWidget {
  final Flashcard card;
  final bool showAnswer;
  final VoidCallback onToggle;

  const FlashcardCard({
    super.key,
    required this.card,
    required this.showAnswer,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE8E7F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEFF),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              showAnswer
                  ? Icons.lightbulb_rounded
                  : Icons.help_outline_rounded,
              size: 36,
              color: const Color(0xFF6558F5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            showAnswer ? 'ANSWER' : 'QUESTION',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            showAnswer ? card.answer : card.question,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: Color(0xFF25243A),
            ),
          ),
          const SizedBox(height: 30),
          if (!showAnswer)
            FilledButton.icon(
              onPressed: onToggle,
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Show Answer'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(180, 52),
                backgroundColor: const Color(0xFF6558F5),
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: onToggle,
              icon: const Icon(Icons.refresh),
              label: const Text('Show Question'),
            ),
          const SizedBox(height: 24),
          const Text(
            'Focus • Practice • Remember',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
