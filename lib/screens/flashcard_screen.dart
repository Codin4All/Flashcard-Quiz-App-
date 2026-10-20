
import 'package:flutter/material.dart';
import 'package:task_1/model/flashcard.dart';
import '../data/flashcard_data.dart';
import '../widgets/flashcard_card.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() =>
      _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final List<Flashcard> cards = List.from(initialFlashcards);

  int currentIndex = 0;
  bool showAnswer = false;

  void nextCard() {
    if (currentIndex < cards.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  Future<void> showCardDialog({Flashcard? card}) async {
    final questionController = TextEditingController(
      text: card?.question ?? '',
    );

    final answerController = TextEditingController(
      text: card?.answer ?? '',
    );

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
              card == null ? 'Add Flashcard' : 'Edit Flashcard',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: questionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Question',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: answerController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Answer',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final question =
                      questionController.text.trim();
                  final answer =
                      answerController.text.trim();

                  if (question.isEmpty || answer.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Enter both question and answer.',
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    if (card == null) {
                      cards.add(
                        Flashcard(
                          question: question,
                          answer: answer,
                        ),
                      );
                      currentIndex = cards.length - 1;
                    } else {
                      card.question = question;
                      card.answer = answer;
                    }

                    showAnswer = false;
                  });

                  Navigator.pop(dialogContext, true);
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );

      if (result == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              card == null
                  ? 'Flashcard added successfully!'
                  : 'Flashcard updated successfully!',
            ),
          ),
        );
      }
    } finally {
      questionController.dispose();
      answerController.dispose();
    }
  }

  Future<void> deleteCard() async {
    if (cards.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Flashcard?'),
        content: const Text(
          'Are you sure you want to delete this flashcard?',
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () =>
                Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      cards.removeAt(currentIndex);

      if (cards.isEmpty) {
        currentIndex = 0;
      } else if (currentIndex >= cards.length) {
        currentIndex = cards.length - 1;
      }

      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasCards = cards.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(
              Icons.style_rounded,
              color: Color(0xFF6558F5),
            ),
            SizedBox(width: 10),
            Text(
              'Flashcard Quiz',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Add Flashcard',
            onPressed: () => showCardDialog(),
            icon: const Icon(Icons.add_circle_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Learn something new',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                hasCards
                    ? 'Review your questions and test your knowledge.'
                    : 'Add a flashcard to start studying.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              if (hasCards) ...[
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CARD ${currentIndex + 1}',
                      style: const TextStyle(
                        color: Color(0xFF6558F5),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      '${currentIndex + 1} / ${cards.length}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (currentIndex + 1) / cards.length,
                    minHeight: 6,
                    color: const Color(0xFF6558F5),
                    backgroundColor: Colors.deepPurple.shade50,
                  ),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: FlashcardCard(
                    card: cards[currentIndex],
                    showAnswer: showAnswer,
                    onToggle: () {
                      setState(() {
                        showAnswer = !showAnswer;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: currentIndex > 0
                            ? previousCard
                            : null,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Previous'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed:
                            currentIndex < cards.length - 1
                                ? nextCard
                                : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          backgroundColor:
                              const Color(0xFF6558F5),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => showCardDialog(
                          card: cards[currentIndex],
                        ),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: deleteCard,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        label: const Text('Delete'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.style_outlined,
                          size: 72,
                          color: Color(0xFF6558F5),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No flashcards yet!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: () => showCardDialog(),
                          icon: const Icon(Icons.add),
                          label: const Text('Add First Card'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
