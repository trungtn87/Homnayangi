import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/dish.dart';
import '../ui/category_icon.dart';

class SlotReel extends StatefulWidget {
  const SlotReel({
    super.key,
    required this.category,
    required this.options,
    required this.spinToken,
    required this.finalDish,
    required this.duration,
  });

  final DishCategory category;
  final List<Dish> options;
  final int spinToken;
  final Dish? finalDish;
  final Duration duration;

  @override
  State<SlotReel> createState() => _SlotReelState();
}

class _SlotReelState extends State<SlotReel> {
  Timer? _timer;
  Timer? _stopTimer;
  var _currentIndex = 0;
  var _running = false;

  @override
  void initState() {
    super.initState();
    _syncToFinal();
  }

  @override
  void didUpdateWidget(covariant SlotReel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spinToken != oldWidget.spinToken && widget.spinToken > 0) {
      _startSpin();
    } else if (!_running && widget.finalDish != oldWidget.finalDish) {
      _syncToFinal();
    }
  }

  void _startSpin() {
    _timer?.cancel();
    _stopTimer?.cancel();

    if (widget.options.isEmpty) return;

    setState(() => _running = true);

    _timer = Timer.periodic(const Duration(milliseconds: 90), (_) {
      if (!mounted || widget.options.isEmpty) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.options.length;
      });
    });

    _stopTimer = Timer(widget.duration, () {
      _timer?.cancel();
      if (!mounted) return;

      final targetIndex = widget.finalDish == null
          ? _currentIndex
          : widget.options.indexWhere((dish) => dish.id == widget.finalDish!.id);

      setState(() {
        if (targetIndex >= 0) _currentIndex = targetIndex;
        _running = false;
      });
      HapticFeedback.selectionClick();
    });
  }

  void _syncToFinal() {
    if (widget.options.isEmpty) {
      _currentIndex = 0;
      return;
    }

    if (widget.finalDish == null) {
      if (_currentIndex >= widget.options.length) _currentIndex = 0;
      return;
    }

    final index = widget.options.indexWhere((dish) => dish.id == widget.finalDish!.id);
    if (index >= 0) _currentIndex = index;
  }

  Dish? _dishAtOffset(int offset) {
    if (widget.options.isEmpty) return null;
    final length = widget.options.length;
    final index = (_currentIndex + offset + length) % length;
    return widget.options[index];
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tint = Color(widget.category.tintValue);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E5EA)),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 5),
              color: tint,
              child: Text(
                widget.category.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            _ReelCell(
              dish: _dishAtOffset(-1),
              muted: true,
              category: widget.category,
            ),
            Container(
              decoration: BoxDecoration(
                color: tint,
                border: const Border.symmetric(
                  horizontal: BorderSide(color: Color(0xFFD6DAE1)),
                ),
              ),
              child: _ReelCell(
                dish: _dishAtOffset(0),
                category: widget.category,
                center: true,
                spinning: _running,
              ),
            ),
            _ReelCell(
              dish: _dishAtOffset(1),
              muted: true,
              category: widget.category,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReelCell extends StatelessWidget {
  const _ReelCell({
    required this.dish,
    required this.category,
    this.muted = false,
    this.center = false,
    this.spinning = false,
  });

  final Dish? dish;
  final DishCategory category;
  final bool muted;
  final bool center;
  final bool spinning;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: center ? 78 : 56,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 80),
        opacity: muted ? 0.34 : 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 85),
              transitionBuilder: (child, animation) {
                final position = Tween<Offset>(
                  begin: const Offset(0, -0.35),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOut,
                  ),
                );
                return ClipRect(
                  child: SlideTransition(
                    position: position,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                );
              },
              child: Column(
                key: ValueKey(
                  (dish?.id ?? 'empty') +
                      (center ? '_center' : '_outer') +
                      (muted ? '_muted' : '_solid'),
                ),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    categoryIcon(category),
                    size: center ? 22 : 17,
                    color: Color(category.accentValue),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    dish?.name ?? 'Chưa có món',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: center ? 12 : 10.5,
                      height: 1.12,
                      fontWeight: center ? FontWeight.w600 : FontWeight.w500,
                      color: spinning && center
                          ? const Color(0xFF566171)
                          : const Color(0xFF20242A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
