import 'package:flutter/material.dart';

class WeightSlider extends StatefulWidget {
  final ValueChanged<int>? onChanged;

  const WeightSlider({super.key, this.onChanged});

  @override
  State<WeightSlider> createState() => _WeightSliderState();
}

class _WeightSliderState extends State<WeightSlider> {
  int _weight = 58;
  double _dragAccumulator = 0;

  void _updateWeight(int newValue) {
    setState(() {
      _weight = newValue.clamp(0, 200);
    });

    widget.onChanged?.call(_weight);
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

      child: LayoutBuilder(
        builder: (context, constraints) {
          // عرض واقعی کارت
          final width = constraints.maxWidth;

          // -----------------------------------------
          // اندازه فونت عنوان
          // -----------------------------------------

          final titleFontSize = width < 120 ? 16.0 : 20.0;

          // -----------------------------------------
          // اندازه فونت اعداد کناری
          // -----------------------------------------

          final sideFontSize = width < 120 ? 12.0 : 14.0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // =====================================
              // عنوان
              // =====================================
              SizedBox(
                width: double.infinity,
                height: 28,

                child: FittedBox(
                  fit: BoxFit.scaleDown,

                  child: Text(
                    'Weight (in kg)',
                    maxLines: 1,
                    softWrap: false,

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // =====================================
              // Arrow
              // =====================================
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.white54,
                size: 20,
              ),

              const SizedBox(height: 6),

              // =====================================
              // Weight Selector
              // =====================================
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  _dragAccumulator += details.delta.dx;

                  if (_dragAccumulator > 15) {
                    _updateWeight(_weight - 1);
                    _dragAccumulator = 0;
                  } else if (_dragAccumulator < -15) {
                    _updateWeight(_weight + 1);
                    _dragAccumulator = 0;
                  }
                },

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(50),
                  ),

                  child: Row(
                    children: [
                      // =================================
                      // عدد قبلی
                      // =================================
                      Expanded(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,

                          child: Text(
                            '${_weight - 1}',
                            maxLines: 1,
                            softWrap: false,

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: sideFontSize,
                            ),
                          ),
                        ),
                      ),

                      // =================================
                      // عدد اصلی
                      // =================================
                      Expanded(
                        flex: 2,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,

                          child: Text(
                            '$_weight',
                            maxLines: 1,
                            softWrap: false,

                            textAlign: TextAlign.center,

                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // =================================
                      // عدد بعدی
                      // =================================
                      Expanded(
                        flex: 1,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,

                          child: Text(
                            '${_weight + 1}',
                            maxLines: 1,
                            softWrap: false,

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: sideFontSize,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
