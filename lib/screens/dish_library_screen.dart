import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../state/app_controller.dart';
import '../ui/category_icon.dart';
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
          padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
          children: [
            Text(
              'Kho món ăn',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            const Text(
              'Chỉ các món đang bật mới xuất hiện khi quay.',
              style: TextStyle(color: Color(0xFF68717D)),
            ),
            const SizedBox(height: 22),
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
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 4),
            OutlinedButton.icon(
              onPressed: () => _quickAdd(context),
              icon: const Icon(Icons.add_rounded),
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
    final accent = Color(category.accentValue);

    return Material(
      color: Color(category.tintValue),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(categoryIcon(category), color: accent, size: 23),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$enabled/$total món đang bật',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF68717D),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}
