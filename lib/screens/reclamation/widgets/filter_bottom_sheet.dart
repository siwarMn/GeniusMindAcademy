import 'package:codajoy/controllers/reclamation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterBottomSheet extends StatelessWidget {
  FilterBottomSheet({Key? key}) : super(key: key);

  final ReclamationController controller = Get.find();

  final List<String> statuses = ['All', 'Open', 'In Progress', 'Resolved', 'Closed'];
  final List<String> categories = ['All', 'App Bug', 'Course Content', 'Payment', 'Account', 'Feature Request', 'Other'];
  final List<String> priorities = ['All', 'Low', 'Medium', 'High', 'Critical'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 8,
                children: statuses.map((status) {
                  bool isSelected = controller.selectedStatus.value == status;
                  return ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (selected) {
                      controller.selectedStatus.value = status;
                      controller.applyFilters();
                    },
                  );
                }).toList(),
              )),

          const SizedBox(height: 20),
          const Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 8,
                children: categories.map((category) {
                  bool isSelected = controller.selectedCategory.value == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      controller.selectedCategory.value = category;
                      controller.applyFilters();
                    },
                  );
                }).toList(),
              )),

          const SizedBox(height: 20),
          const Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(() => Wrap(
                spacing: 8,
                children: priorities.map((priority) {
                  bool isSelected = controller.selectedPriority.value == priority;
                  return ChoiceChip(
                    label: Text(priority),
                    selected: isSelected,
                    onSelected: (selected) {
                      controller.selectedPriority.value = priority;
                      controller.applyFilters();
                    },
                  );
                }).toList(),
              )),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                controller.selectedStatus.value = 'All';
                controller.selectedCategory.value = 'All';
                controller.selectedPriority.value = 'All';
                controller.applyFilters();
                Get.back();
              },
              child: const Text('Reset Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
