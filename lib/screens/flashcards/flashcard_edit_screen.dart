import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/flashcard_controller.dart';
import '../../models/flashcard_model.dart';

class FlashcardEditScreen extends StatefulWidget {
  final int? cardId; // null = new card

  const FlashcardEditScreen({super.key, this.cardId});

  @override
  State<FlashcardEditScreen> createState() => _FlashcardEditScreenState();
}

class _FlashcardEditScreenState extends State<FlashcardEditScreen> {
  final _frontCtrl = TextEditingController();
  final _backCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<FlashcardController>();

  @override
  void initState() {
    super.initState();
    if (widget.cardId != null) {
      final Flashcard? card = controller.getById(widget.cardId!);
      if (card != null) {
        _frontCtrl.text = card.front;
        _backCtrl.text = card.back;
        _categoryCtrl.text = card.category;
      }
    }
  }

  // void _save() {
  //   if (!_formKey.currentState!.validate()) return;

  //   if (widget.cardId == null) {
  //     controller.addCard(_frontCtrl.text.trim(), _backCtrl.text.trim(),_categoryCtrl.text.trim());
  //   } else {
  //     controller.updateCard(
  //       widget.cardId!,
  //       _frontCtrl.text.trim(),
  //       _backCtrl.text.trim(),
  //       _categoryCtrl.text.trim(),
  //     );
  //   }
  //   Get.back();
  // }
Future<void> _save() async {
  final front = _frontCtrl.text.trim();
  final back = _backCtrl.text.trim();
  final category = _categoryCtrl.text.trim();

  try {
    if (widget.cardId == null) {
      await controller.addCard(front, back, category);
    } else {
      await controller.updateCard(widget.cardId!, front, back, category);
    }

    // ✅ Close screen FIRST
    Navigator.of(context).pop();

    // ✅ Show feedback safely (Flutter native)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved successfully ✅')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error while saving ❌')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.cardId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Flashcard' : 'New Flashcard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _frontCtrl,
                decoration: const InputDecoration(labelText: 'Front (question)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _backCtrl,
                decoration: const InputDecoration(labelText: 'Back (answer)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryCtrl,
                decoration: const InputDecoration(labelText: 'Category of card'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'Save changes' : 'Add card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
