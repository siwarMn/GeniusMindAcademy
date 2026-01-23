import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:codajoy/theme/app_theme.dart';
import '../../controllers/flashcard_controller.dart';
import 'flashcard_edit_screen.dart';
import './flashcards_session_screen.dart';


class FlashcardListScreen extends StatelessWidget {
  FlashcardListScreen({super.key});

  final FlashcardController controller =
      Get.put(FlashcardController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Commencer',
            onPressed: () {
              final ids = controller.filteredCards.map((c) => c.id).toList();
              if (ids.isEmpty) {
                Get.snackbar('Training', 'Aucune carte avec ces filtres',
                    snackPosition: SnackPosition.BOTTOM);
                return;
              }
              Get.to(() => FlashcardsSessionScreen(cardIds: ids));
            },
          ),
        ],
      ),
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // 🔎 Filters: search + category
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // search field
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Rechercher…',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: controller.setSearchFilter,
                  ),
                ),
                const SizedBox(width: 8),
                // category dropdown
                Expanded(
                  flex: 1,
                  child: Obx(() {
                    final categories = controller.availableCategories;
                    return DropdownButtonFormField<String>(
                      isDense: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Catégorie',
                      ),
                      value: controller.categoryFilter.value.isEmpty
                          ? null
                          : controller.categoryFilter.value,
                      items: [
                        const DropdownMenuItem<String>(
                          value: '',
                          child: Text('Toutes'),
                        ),
                        ...categories.map(
                          (cat) => DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          controller.setCategoryFilter(value == '' ? null : value),
                    );
                  }),
                ),
              ],
            ),
          ),

          // 📋 List of filtered cards
          Expanded(
            child: Obx(() {
              final cards = controller.filteredCards;

              if (cards.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.style_outlined, size: 80, color: AppTheme.textHint),
                      const SizedBox(height: 16),
                      Text(
                        'Aucune flashcard',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Cliquez sur + pour en creer une',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textHint,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return ListTile(
                    title: Text(card.front),
                    subtitle: Text(card.back),
                    trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    if (card.memorized)
      Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Chip(
          label: const Text('Memorise'),
          backgroundColor: AppTheme.successLight,
          labelStyle: TextStyle(color: AppTheme.successColor, fontSize: 12),
        ),
      ),
    Chip(label: Text(card.category)),
    IconButton(
      icon: Icon(Icons.delete, color: AppTheme.errorColor),
      onPressed: () => controller.deleteCard(card.id),
    ),
  ],
),

                    // trailing: Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Chip(
                    //       label: Text(card.category),
                    //     ),
                    //     IconButton(
                    //       icon: const Icon(Icons.delete),
                    //       onPressed: () => controller.deleteCard(card.id),
                    //     ),
                    //   ],
                    // ),
                    onTap: () =>
                        Get.to(() => FlashcardEditScreen(cardId: card.id)),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const FlashcardEditScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }
}
