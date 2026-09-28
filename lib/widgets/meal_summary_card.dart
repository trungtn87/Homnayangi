import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../services/meal_randomizer.dart';

class MealSummaryCard extends StatelessWidget {
  const MealSummaryCard({
    super.key,
    required this.selection,
    required this.saved,
    required this.onSave,
    required this.onSpinAgain,
  });

  final MealSelection selection;
  final bool saved;
  final VoidCallback onSave;
  final VoidCallback onSpinAgain;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tổng hợp thực đơn',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              category: DishCategory.main,
              name: selection.mainDish.name,
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              category: DishCategory.side,
              name: selection.sideDish.name,
            ),
            const SizedBox(height: 8),
            _SummaryRow(
              category: DishCategory.soup,
              name: selection.soup.name,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: saved ? null : onSave,
              icon: Icon(saved ? Icons.check_circle : Icons.check),
              label: Text(saved ? 'Đã lưu thực đơn' : 'Chốt thực đơn'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onSpinAgain,
              icon: const Icon(Icons.refresh),
              label: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.category, required this.name});

  final DishCategory category;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Color(category.tintValue),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(category.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.label,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF68717D)),
                ),
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
