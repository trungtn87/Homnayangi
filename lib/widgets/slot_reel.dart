import 'dart:async';

import 'package:flutter/material.dart';

import '../models/dish.dart';

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
    _timer = Timer.periodic(const Duration(milliseconds: 85), (_) {
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
    });
  }

  void _syncToFinal() {
    if (widget.options.isEmpty) {
      _currentIndex = 0;
      return;
    }
    if (widget.finalDish == null) {
      _currentIndex = _currentIndex.clamp(0, widget.options.length - 1);
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              color: tint,
              child: Text(
                widget.category.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
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
      height: center ? 78 : 58,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 80),
        opacity: muted ? 0.36 : 1,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category.emoji,
                  style: TextStyle(fontSize: center ? 25 : 18),
                ),
                const SizedBox(height: 3),
                Text(
                  dish?.name ?? 'Chưa có món',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: center ? 13 : 11,
                    height: 1.05,
                    fontWeight: center ? FontWeight.w700 : FontWeight.w500,
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
    );
  }
}
