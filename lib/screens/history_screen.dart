import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../models/meal.dart';
import '../state/app_controller.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.controller});

  final AppController controller;

  String _formatDate(DateTime date) {
    String two(int value) => value.toString().padLeft(2, '0');
    return two(date.day) +
        '/' +
        two(date.month) +
        '/' +
        date.year.toString() +
        ' ' +
        two(date.hour) +
        ':' +
        two(date.minute);
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
              icon: const Icon(Icons.delete_outline),
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
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            const Text(
              'Lịch sử thực đơn',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text(
              'Các thực đơn bạn đã chốt sẽ được lưu tại đây.',
              style: TextStyle(color: Color(0xFF68717D)),
            ),
            const SizedBox(height: 18),
            if (history.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 72),
                child: Column(
                  children: [
                    Icon(Icons.history, size: 48, color: Color(0xFFB5BBC4)),
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
                  borderRadius: BorderRadius.circular(12),
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
                        Text('🍖  ' + meal.mainDish),
                        const SizedBox(height: 5),
                        Text('🥬  ' + meal.sideDish),
                        const SizedBox(height: 5),
                        Text('🍲  ' + meal.soup),
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

class _HistoryDish extends StatelessWidget {
  const _HistoryDish({required this.category, required this.name});

  final DishCategory category;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(category.tintValue),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(category.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
