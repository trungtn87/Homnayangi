import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../models/meal.dart';
import '../state/app_controller.dart';
import '../ui/category_icon.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.controller});

  final AppController controller;

  String _formatDate(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${two(date.day)}/${two(date.month)}/${date.year} '
        '${two(date.hour)}:${two(date.minute)}';
  }

  Future<void> _showMeal(BuildContext context, Meal meal) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _formatDate(meal.createdAt),
              style: const TextStyle(color: Color(0xFF68717D)),
            ),
            const SizedBox(height: 12),
            _HistoryDish(category: DishCategory.main, name: meal.mainDish),
            const SizedBox(height: 8),
            _HistoryDish(category: DishCategory.side, name: meal.sideDish),
            const SizedBox(height: 8),
            _HistoryDish(category: DishCategory.soup, name: meal.soup),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                await controller.deleteMeal(meal.id);
                if (sheetContext.mounted) Navigator.pop(sheetContext);
              },
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Xóa thực đơn này'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final history = controller.history;

        return ListView(
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
          children: [
            Text(
              'Lịch sử thực đơn',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            const Text(
              'Các thực đơn bạn đã chốt sẽ được lưu tại đây.',
              style: TextStyle(color: Color(0xFF68717D)),
            ),
            const SizedBox(height: 20),
            if (history.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 72),
                child: Column(
                  children: [
                    Icon(Icons.history_rounded, size: 44, color: Color(0xFFB5BBC4)),
                    SizedBox(height: 10),
                    Text(
                      'Chưa có thực đơn nào được lưu.',
                      style: TextStyle(color: Color(0xFF68717D)),
                    ),
                  ],
                ),
              ),
            for (final meal in history) ...[
              Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _showMeal(context, meal),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(meal.createdAt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF68717D),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _CompactDishRow(
                          category: DishCategory.main,
                          name: meal.mainDish,
                        ),
                        const SizedBox(height: 7),
                        _CompactDishRow(
                          category: DishCategory.side,
                          name: meal.sideDish,
                        ),
                        const SizedBox(height: 7),
                        _CompactDishRow(
                          category: DishCategory.soup,
                          name: meal.soup,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }
}

class _CompactDishRow extends StatelessWidget {
  const _CompactDishRow({required this.category, required this.name});

  final DishCategory category;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          categoryIcon(category),
          size: 18,
          color: Color(category.accentValue),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 14,
              height: 1.3,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryDish extends StatelessWidget {
  const _HistoryDish({required this.category, required this.name});

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
          Icon(
            categoryIcon(category),
            size: 21,
            color: Color(category.accentValue),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
