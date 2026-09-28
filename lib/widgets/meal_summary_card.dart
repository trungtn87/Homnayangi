import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../services/meal_randomizer.dart';
import '../ui/category_icon.dart';

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
            Text(
              'Tổng hợp thực đơn',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 14),
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
              icon: Icon(saved ? Icons.check_circle_rounded : Icons.check_rounded),
              label: Text(saved ? 'Đã lưu thực đơn' : 'Chốt thực đơn'),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: onSpinAgain,
              icon: const Icon(Icons.refresh_rounded),
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
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              categoryIcon(category),
              size: 19,
              color: Color(category.accentValue),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF68717D),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
