import 'dart:async';

import 'package:flutter/material.dart';

import '../models/dish.dart';
import '../services/meal_randomizer.dart';
import '../state/app_controller.dart';
import '../widgets/meal_summary_card.dart';
import '../widgets/slot_reel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.controller});

  final AppController controller;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MealSelection? _pendingSelection;
  MealSelection? _visibleSelection;
  var _spinToken = 0;
  var _isSpinning = false;
  var _savedCurrent = false;
  Timer? _finishTimer;

  Future<void> _spin() async {
    if (_isSpinning) return;

    if (!widget.controller.canSpin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mỗi nhóm cần ít nhất 1 món đang bật trước khi quay.'),
        ),
      );
      return;
    }

    final selection = widget.controller.randomizer.generate(
      widget.controller.dishes,
    );

    _finishTimer?.cancel();
    setState(() {
      _pendingSelection = selection;
      _visibleSelection = null;
      _savedCurrent = false;
      _isSpinning = true;
      _spinToken++;
    });

    _finishTimer = Timer(const Duration(milliseconds: 2550), () {
      if (!mounted) return;
      setState(() {
        _visibleSelection = _pendingSelection;
        _isSpinning = false;
      });
    });
  }

  Future<void> _saveSelection() async {
    final selection = _visibleSelection;
    if (selection == null || _savedCurrent) return;

    await widget.controller.saveMeal(selection);
    if (!mounted) return;
    setState(() => _savedCurrent = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã lưu thực đơn vào lịch sử.')),
    );
  }

  @override
  void dispose() {
    _finishTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final finalSelection = _pendingSelection;

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            const Text(
              'Hôm nay ăn gì?',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text(
              'Quay một lần để chọn món chính, món phụ và canh.',
              style: TextStyle(color: Color(0xFF68717D)),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SlotReel(
                      category: DishCategory.main,
                      options: widget.controller.enabledDishesFor(
                        DishCategory.main,
                      ),
                      spinToken: _spinToken,
                      finalDish: finalSelection?.mainDish,
                      duration: const Duration(milliseconds: 1450),
                    ),
                    const SizedBox(width: 8),
                    SlotReel(
                      category: DishCategory.side,
                      options: widget.controller.enabledDishesFor(
                        DishCategory.side,
                      ),
                      spinToken: _spinToken,
                      finalDish: finalSelection?.sideDish,
                      duration: const Duration(milliseconds: 1950),
                    ),
                    const SizedBox(width: 8),
                    SlotReel(
                      category: DishCategory.soup,
                      options: widget.controller.enabledDishesFor(
                        DishCategory.soup,
                      ),
                      spinToken: _spinToken,
                      finalDish: finalSelection?.soup,
                      duration: const Duration(milliseconds: 2450),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 54,
              child: FilledButton.icon(
                onPressed: _isSpinning ? null : _spin,
                icon: Icon(_isSpinning ? Icons.hourglass_top : Icons.casino),
                label: Text(
                  _isSpinning ? 'Đang quay...' : 'QUAY THỰC ĐƠN',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            if (_isSpinning)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    'Đang chọn thực đơn...',
                    style: TextStyle(color: Color(0xFF68717D)),
                  ),
                ),
              ),
            if (_visibleSelection != null)
              MealSummaryCard(
                selection: _visibleSelection!,
                saved: _savedCurrent,
                onSave: _saveSelection,
                onSpinAgain: _spin,
              ),
          ],
        );
      },
    );
  }
}
