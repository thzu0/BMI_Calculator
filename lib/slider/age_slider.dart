import 'package:flutter/material.dart';

class AgeSlider extends StatefulWidget {
  final int initialAge;
  final ValueChanged<int>? onChanged;

  const AgeSlider({super.key, this.initialAge = 22, this.onChanged});

  @override
  State<AgeSlider> createState() => _AgeSliderState();
}

class _AgeSliderState extends State<AgeSlider> {
  late int _age;
  double _dragAccumulator = 0;

  @override
  void initState() {
    super.initState();
    _age = widget.initialAge;
  }

  @override
  void didUpdateWidget(covariant AgeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialAge != widget.initialAge) {
      setState(() {
        _age = widget.initialAge;
      });
    }
  }

  void _updateAge(int newValue) {
    setState(() {
      _age = newValue.clamp(1, 120);
    });
    widget.onChanged?.call(_age);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Age',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Icon(Icons.arrow_drop_down, color: Colors.white54, size: 20),
          const SizedBox(height: 10),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              _dragAccumulator += details.delta.dx;
              if (_dragAccumulator > 15) {
                _updateAge(_age - 1);
                _dragAccumulator = 0;
              } else if (_dragAccumulator < -15) {
                _updateAge(_age + 1);
                _dragAccumulator = 0;
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  // عدد قبلی (سمت چپ)
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${_age - 1}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                    ),
                  ),

                  // عدد اصلی (دقیقاً در مرکز با مقیاس‌گذاری هوشمند)
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '$_age',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // عدد بعدی (سمت راست)
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${_age + 1}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
