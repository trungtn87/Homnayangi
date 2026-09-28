import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../state/app_controller.dart';

class DishListScreen extends StatelessWidget {
  const DishListScreen({
    super.key,
    required this.controller,
    required this.category,
  });

  final AppController controller;
  final DishCategory category;

  Future<void> _openEditor(BuildContext context, [Dish? dish]) async {
    final nameController = TextEditingController(text: dish?.name ?? '');
    var selectedCategory = dish?.category ?? category;

    final action = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(dish == null ? 'Thêm món mới' : 'Sửa món'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Tên món'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<DishCategory>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(labelText: 'Nhóm món'),
                items: [
                  for (final item in DishCategory.values)
                    DropdownMenuItem(value: item, child: Text(item.label)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() => selectedCategory = value);
                  }
                },
              ),
            ],
          ),
          actions: [
            if (dish != null)
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, 'delete'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, 'save'),
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );

    final name = nameController.text.trim();
    nameController.dispose();

    if (action == 'delete' && dish != null) {
      await controller.deleteDish(dish.id);
      return;
    }

    if (action != 'save' || name.isEmpty) return;

    if (dish == null) {
      await controller.addDish(name, selectedCategory);
    } else {
      await controller.updateDish(
        dish.copyWith(name: name, category: selectedCategory),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final dishes = controller.dishesFor(category);

        return Scaffold(
          appBar: AppBar(
            title: Text(category.label),
            actions: [
              TextButton.icon(
                onPressed: () => _openEditor(context),
                icon: const Icon(Icons.add),
                label: const Text('Thêm'),
              ),
            ],
          ),
          body: dishes.isEmpty
              ? Center(
                  child: FilledButton.icon(
                    onPressed: () => _openEditor(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm món đầu tiên'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  itemCount: dishes.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final dish = dishes[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                      leading: Text(
                        dish.category.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        dish.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: dish.enabled ? null : Colors.grey,
                        ),
                      ),
                      onTap: () => _openEditor(context, dish),
                      trailing: Switch(
                        value: dish.enabled,
                        onChanged: (value) =>
                            controller.toggleDish(dish, value),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
