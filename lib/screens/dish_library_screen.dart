import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../state/app_controller.dart';
import 'dish_list_screen.dart';

class DishLibraryScreen extends StatelessWidget {
  const DishLibraryScreen({super.key, required this.controller});

  final AppController controller;

  Future<void> _quickAdd(BuildContext context) async {
    var category = DishCategory.main;
    final textController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Thêm món nhanh'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: textController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Tên món',
                  hintText: 'Ví dụ: Tôm rang muối',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DishCategory>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Nhóm món'),
                items: [
                  for (final item in DishCategory.values)
                    DropdownMenuItem(value: item, child: Text(item.label)),
                ],
                onChanged: (value) {
                  if (value != null) setDialogState(() => category = value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );

    if (result == true && textController.text.trim().isNotEmpty) {
      await controller.addDish(textController.text, category);
    }
    textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            const Text(
              'Kho món ăn',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text(
              'Chỉ các món đang bật mới xuất hiện khi quay.',
              style: TextStyle(color: Color(0xFF68717D)),
            ),
            const SizedBox(height: 20),
            for (final category in DishCategory.values) ...[
              _CategoryCard(
                category: category,
                total: controller.dishesFor(category).length,
                enabled: controller.enabledDishesFor(category).length,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DishListScreen(
                        controller: controller,
                        category: category,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => _quickAdd(context),
              icon: const Icon(Icons.add),
              label: const Text('Thêm món nhanh'),
            ),
          ],
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.total,
    required this.enabled,
    required this.onTap,
  });

  final DishCategory category;
  final int total;
  final int enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(category.tintValue),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(category.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.label,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '$enabled/$total món đang bật',
                      style: const TextStyle(color: Color(0xFF68717D)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
