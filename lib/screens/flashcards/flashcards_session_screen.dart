import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/flashcard_controller.dart';
import '../../models/flashcard_model.dart';
import './flashcard_study_card.dart';

class FlashcardsSessionScreen extends StatefulWidget {
  final List<int> cardIds;

  const FlashcardsSessionScreen({super.key, required this.cardIds});

  @override
  State<FlashcardsSessionScreen> createState() => _FlashcardsSessionScreenState();
}

class _FlashcardsSessionScreenState extends State<FlashcardsSessionScreen> {
  final controller = Get.find<FlashcardController>();

  late List<int> _sessionIds;
  int _index = 0;
  final List<int> _wrongIds = [];
  int _token = 0; // forces fresh flip state every step

void _showCongratsAndExit() async {
  await showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Congrats',
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('🎉', style: TextStyle(fontSize: 56)),
                SizedBox(height: 8),
                Text(
                  'Congratulations!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text('You memorized all cards ✅', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1).animate(anim),
          child: child,
        ),
      );
    },
  );

  // auto close after short delay
  await Future.delayed(const Duration(milliseconds: 900));
  if (mounted) Navigator.of(context).pop(); // close dialog
  Get.back(); // exit session screen -> back to list
}

  @override
  void initState() {
    super.initState();
    _sessionIds = List<int>.from(widget.cardIds);
  }
  void _next() {
  setState(() => _token++);

  if (_index < _sessionIds.length - 1) {
    setState(() => _index++);
    return;
  }

  if (_wrongIds.isNotEmpty) {
    setState(() {
      _sessionIds = List<int>.from(_wrongIds);
      _wrongIds.clear();
      _index = 0;
      _token++; // important
    });
    Get.snackbar('Round finished', 'Retry only missed cards 👎');
  } else {
    _showCongratsAndExit(); // we’ll add this below
  }
}

  // void _next() {
  //   if (_index < _sessionIds.length - 1) {
  //     setState(() => _index++);
  //     return;
  //   }

  //   // finished this round
  //   if (_wrongIds.isNotEmpty) {
  //     // start a new round with only wrong cards
  //     setState(() {
  //       _sessionIds = List<int>.from(_wrongIds);
  //       _wrongIds.clear();
  //       _index = 0;
  //     });
  //     Get.snackbar('Round finished', 'Now retry only the cards you missed 👎');
  //   } else {
  //     // all correct
  //     Get.snackbar('Bravo 🎉', 'You completed all cards!');
  //     Get.back();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (_sessionIds.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No cards to study')),
      );
    }

    final currentId = _sessionIds[_index];
    final Flashcard? card = controller.getById(currentId);

    if (card == null) {
      return const Scaffold(
        body: Center(child: Text('Card not found')),
      );
    }

    return Scaffold(
  appBar: AppBar(title: Text('Study ${_index + 1}/${_sessionIds.length}')),
  body: Center(
  child: AnimatedSwitcher(
    duration: const Duration(milliseconds: 250),
    transitionBuilder: (child, anim) {
      return FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.12, 0),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      );
    },
    child: FlashcardStudyCard(
      key: ValueKey(_token),
      front: card.front,
      back: card.back,
      category: card.category,
      onKnown: () { controller.markKnown(card.id); _next(); },
      onUnknown: () { controller.markUnknown(card.id); _wrongIds.add(card.id); _next(); },
    ),
  ),
),

  // body: Center(
  //   child: AnimatedSwitcher(
  //     duration: const Duration(milliseconds: 250),
  //     transitionBuilder: (child, animation) {
  //       final offsetAnimation = Tween<Offset>(
  //         begin: const Offset(0.15, 0),
  //         end: Offset.zero,
  //       ).animate(animation);

  //       return SlideTransition(
  //         position: offsetAnimation,
  //         child: FadeTransition(opacity: animation, child: child),
  //       );
  //     },
  //     child: FlashcardStudyCard(
  //       // key: ValueKey(card.id), // ✅ makes each card fresh
  //       key: ValueKey(_token),
  //       front: card.front,
  //       back: card.back,
  //       category: card.category,
  //       onKnown: () {
  //         controller.markKnown(card.id);
  //         _next();
  //       },
  //       onUnknown: () {
  //         controller.markUnknown(card.id);
  //         _wrongIds.add(card.id);
  //         _next();
  //       },
  //     ),
  //   ),
  // ),
);

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Study ${_index + 1}/${_sessionIds.length}'),
    //   ),
    //   body: Center(
        
    //     child: FlashcardStudyCard(
    //        key: ValueKey(card.id), 
    //       front: card.front,
    //       back: card.back,
    //       category: card.category,
    //       onKnown: () {
    //         controller.markKnown(card.id); // memorized = true
    //         _next();
    //       },
    //       onUnknown: () {
    //         controller.markUnknown(card.id); // memorized = false
    //         _wrongIds.add(card.id);
    //         _next();
    //       },
    //     ),
    //   ),
    // );
    
  }
}
