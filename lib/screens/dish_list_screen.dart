import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../state/app_controller.dart';
import '../ui/category_icon.dart';

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

    final name = nameController.text;
    nameController.dispose();

    if (action == 'delete' && dish != null) {
      await controller.deleteDish(dish.id);
      return;
    }

    if (action != 'save' || name.trim().isEmpty) return;

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
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text('Thêm'),
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: dishes.isEmpty
              ? Center(
                  child: FilledButton.icon(
                    onPressed: () => _openEditor(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Thêm món đầu tiên'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                  itemCount: dishes.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (context, index) {
                    final dish = dishes[index];
                    final accent = Color(dish.category.accentValue);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 3,
                      ),
                      leading: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Color(dish.category.tintValue),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Icon(
                          categoryIcon(dish.category),
                          size: 20,
                          color: accent,
                        ),
                      ),
                      title: Text(
                        dish.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                          color: dish.enabled
                              ? const Color(0xFF20242A)
                              : const Color(0xFF9198A3),
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
