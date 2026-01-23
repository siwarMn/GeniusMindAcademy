import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/flashcard_controller.dart';

class FlashcardStudyScreen extends StatefulWidget {
  final int cardId;

  const FlashcardStudyScreen({super.key, required this.cardId});

  @override
  State<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  bool _isBack = false;

  final controller = Get.find<FlashcardController>();

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _flip() {
    if (_anim.isAnimating) return;
    setState(() => _isBack = !_isBack);
    _anim.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final card = controller.getById(widget.cardId);
    if (card == null) {
      return const Scaffold(body: Center(child: Text('Card not found')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Study')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: _flip,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                final t = _anim.value;
                final angle = t * math.pi;

                final showBack = _isBack;
                final isHalf = angle > (math.pi / 2);

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(showBack ? angle : -angle),
                  child: isHalf
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(math.pi),
                          child: _BackCard(
                            answer: card.back,
                            category: card.category,
                            onKnown: () {
                              controller.markKnown(card.id);
                              Get.back();
                            },
                            onUnknown: () {
                              controller.markUnknown(card.id);
                              Get.back();
                            },
                          ),
                        )
                      : _FrontCard(
                          question: card.front,
                          category: card.category,
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _FrontCard extends StatelessWidget {
  final String question;
  final String category;

  const _FrontCard({required this.question, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: SizedBox(
        width: double.infinity,
        height: 420,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(label: Text(category)),
              ),
              const Spacer(),
              Text(
                question,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              const Text('Tap to reveal', style: TextStyle(color: Colors.grey)),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
class _BackCard extends StatelessWidget {
  final String answer;
  final String category;
  final VoidCallback onKnown;
  final VoidCallback onUnknown;

  const _BackCard({
    required this.answer,
    required this.category,
    required this.onKnown,
    required this.onUnknown,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: SizedBox(
        width: double.infinity,
        height: 420,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(label: Text(category)),
              ),

              const Spacer(),

              // ✅ Answer shown first
              Text(
                answer,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 24),

              // ✅ Buttons under the answer
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onKnown,
                      icon: const Icon(Icons.thumb_up),
                      label: const Text('I knew it'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onUnknown,
                      icon: const Icon(Icons.thumb_down),
                      label: const Text("I didn’t"),
                    ),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
