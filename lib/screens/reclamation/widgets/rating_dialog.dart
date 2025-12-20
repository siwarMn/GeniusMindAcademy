import 'package:codajoy/controllers/reclamation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingDialog extends StatelessWidget {
  final int reclamationId;
  final ReclamationController controller = Get.find();

  RatingDialog({Key? key, required this.reclamationId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxInt selectedRating = 0.obs;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rate this Resolution',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'How satisfied are you with the resolution?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < selectedRating.value
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                        size: 40,
                      ),
                      onPressed: () {
                        selectedRating.value = index + 1;
                      },
                    );
                  }),
                )),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedRating.value > 0) {
                      controller.rateReclamation(
                          reclamationId, selectedRating.value);
                      Get.back();
                    } else {
                      Get.snackbar('Error', 'Please select a rating');
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
