// import 'package:flutter/material.dart';

// class HeightRulerPicker extends StatefulWidget {
//   final double minHeight;
//   final double maxHeight;
//   final double initialHeight;
//   final ValueChanged<double> onChanged;

//   const HeightRulerPicker({
//     super.key,
//     this.minHeight = 100,
//     this.maxHeight = 220,
//     this.initialHeight = 170,
//     required this.onChanged,
//   });

//   @override
//   State<HeightRulerPicker> createState() => _HeightRulerPickerState();
// }

// class _HeightRulerPickerState extends State<HeightRulerPicker> {
//   late ScrollController _scrollController;
//   late double _currentHeight;

//   static const double _tickSpacing = 10.0;

//   @override
//   void initState() {
//     super.initState();
//     _currentHeight = widget.initialHeight;

//     final initialOffset =
//         (widget.initialHeight - widget.minHeight) * _tickSpacing;
//     _scrollController = ScrollController(initialScrollOffset: initialOffset);
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     final offset = _scrollController.offset;
//     final newHeight = widget.minHeight + (offset / _tickSpacing);
//     final clamped = newHeight.clamp(widget.minHeight, widget.maxHeight);

//     if (clamped != _currentHeight) {
//       setState(() {
//         _currentHeight = clamped;
//       });
//       widget.onChanged(clamped);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalTicks = (widget.maxHeight - widget.minHeight).toInt();

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A2038),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           const Text(
//             'Height (in cm)',
//             style: TextStyle(color: Colors.white70, fontSize: 14),
//           ),
//           const SizedBox(height: 8),
//           SizedBox(
//             height: 90,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 NotificationListener<ScrollNotification>(
//                   onNotification: (notification) {
//                     _onScroll();
//                     return true;
//                   },
//                   child: ListView.builder(
//                     controller: _scrollController,
//                     scrollDirection: Axis.horizontal,
//                     physics: const BouncingScrollPhysics(),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: MediaQuery.of(context).size.width / 2 - 20,
//                     ),
//                     itemCount: totalTicks + 1,
//                     itemBuilder: (context, index) {
//                       final value = widget.minHeight + index;
//                       final isMajorTick = value.toInt() % 5 == 0;

//                       return SizedBox(
//                         width: _tickSpacing,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             if (isMajorTick)
//                               Text(
//                                 value.toInt().toString(),
//                                 style: const TextStyle(
//                                   color: Colors.white54,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             const SizedBox(height: 4),
//                             Container(
//                               width: 1.5,
//                               height: isMajorTick ? 24 : 14,
//                               color: isMajorTick
//                                   ? Colors.white70
//                                   : Colors.white30,
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   child: Container(
//                     width: 2.5,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             _currentHeight.toInt().toString(),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//-----------------------------------
// lib/widgets/height_ruler_picker.dart

// lib/widgets/height_ruler_picker.dart
// (یا مسیر خودت: lib/models/slider/height_slider.dart)

// import 'package:flutter/material.dart';

// class HeightRulerPicker extends StatefulWidget {
//   final double minHeight;
//   final double maxHeight;
//   final double initialHeight;
//   final ValueChanged<double> onChanged;

//   const HeightRulerPicker({
//     super.key,
//     this.minHeight = 100,
//     this.maxHeight = 220,
//     this.initialHeight = 170,
//     required this.onChanged,
//   });

//   @override
//   State<HeightRulerPicker> createState() => _HeightRulerPickerState();
// }

// class _HeightRulerPickerState extends State<HeightRulerPicker> {
//   late ScrollController _scrollController;
//   late double _currentHeight;

//   static const double _tickSpacing = 10.0;
//   static const double _tickHeight = 16.0;
//   static const double _selectedTickHeight = 26.0;
//   static const double _labelHeight = 14.0;

//   @override
//   void initState() {
//     super.initState();
//     _currentHeight = widget.initialHeight;

//     final initialOffset =
//         (widget.initialHeight - widget.minHeight) * _tickSpacing;
//     _scrollController = ScrollController(initialScrollOffset: initialOffset);
//     _scrollController.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     final offset = _scrollController.offset;
//     final newHeight = widget.minHeight + (offset / _tickSpacing);
//     final clamped = newHeight.clamp(widget.minHeight, widget.maxHeight);

//     if (clamped.round() != _currentHeight.round()) {
//       setState(() {
//         _currentHeight = clamped;
//       });
//       widget.onChanged(clamped);
//     } else {
//       _currentHeight = clamped;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalTicks = (widget.maxHeight - widget.minHeight).toInt();

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey[800],
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Colors.white70, width: 1.5),
//       ),
//       child: Column(
//         children: [
//           const Text(
//             'Height (in cm)',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           const SizedBox(height: 8),

//           // عدد بزرگ - بالای خط‌کش
//           Text(
//             _currentHeight.round().toString(),
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),

//           SizedBox(
//             height: 90,
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 ListView.builder(
//                   controller: _scrollController,
//                   scrollDirection: Axis.horizontal,
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.symmetric(
//                     horizontal: MediaQuery.of(context).size.width / 2 - 20,
//                   ),
//                   itemCount: totalTicks + 1,
//                   itemBuilder: (context, index) {
//                     final value = widget.minHeight + index;
//                     final isMajorTick = value.toInt() % 5 == 0;
//                     final isSelected = value.round() == _currentHeight.round();

//                     return SizedBox(
//                       width: _tickSpacing,
//                       height: 70,
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           SizedBox(
//                             height: _labelHeight,
//                             child: isMajorTick
//                                 ? OverflowBox(
//                                     minWidth: 0,
//                                     maxWidth: 50,
//                                     minHeight: 0,
//                                     maxHeight: _labelHeight,
//                                     child: Text(
//                                       value.toInt().toString(),
//                                       textAlign: TextAlign.center,
//                                       softWrap: false,
//                                       style: TextStyle(
//                                         color: isSelected
//                                             ? Colors.white
//                                             : Colors.white54,
//                                         fontSize: 11,
//                                         fontWeight: isSelected
//                                             ? FontWeight.bold
//                                             : FontWeight.normal,
//                                       ),
//                                     ),
//                                   )
//                                 : null,
//                           ),
//                           const SizedBox(height: 6),
//                           Container(
//                             width: isSelected ? 2.2 : 1.5,
//                             height: isSelected
//                                 ? _selectedTickHeight
//                                 : _tickHeight,
//                             decoration: BoxDecoration(
//                               color: isSelected ? Colors.white : Colors.white30,
//                               borderRadius: BorderRadius.circular(2),
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),

//                 // نشانگر ثابت وسط
//                 Positioned(
//                   bottom: 0,
//                   child: Container(
//                     width: 2.5,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//--------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_scale_ruler/flutter_scale_ruler.dart';

// class HeightSlider extends StatefulWidget {
//   final String title;
//   const HeightSlider({super.key, required this.title});

//   @override
//   State<HeightSlider> createState() => _HeightSliderState();
// }

// class _HeightSliderState extends State<HeightSlider> {
//   ScaleValue? _scaleValueCms;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey[500],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         children: [
//           Text(
//             widget.title,
//             style: const TextStyle(
//               color: Colors.white70,
//               fontSize: 13,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             "${_scaleValueCms?.cms ?? "0"}",
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           ScaleRuler.lengthMeasurement(
//             maxValue: 210,
//             minValue: 0,
//             initialValue: 40,
//             axis: Axis.horizontal,
//             backgroundColor: Colors.grey[500]!,
//             sliderActiveColor: Colors.grey[800]!,
//             sliderInactiveColor: Colors.white70,
//             onChanged: (ScaleValue? scaleValue) {
//               if (mounted) {
//                 setState(() {
//                   _scaleValueCms = scaleValue;
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//-------------------------------------------
//best slider that i saw

import 'package:flutter/material.dart';

class HeightSliderCard extends StatefulWidget {
  final int initialHeight;
  final int minHeight;
  final int maxHeight;
  final ValueChanged<int> onChanged;

  const HeightSliderCard({
    super.key,
    this.initialHeight = 172,
    this.minHeight = 100,
    this.maxHeight = 220,
    required this.onChanged,
  });

  @override
  State<HeightSliderCard> createState() => _HeightSliderCardState();
}

class _HeightSliderCardState extends State<HeightSliderCard> {
  late ScrollController _scrollController;
  late int _selectedHeight;

  // عرض هر آیتم
  final double _itemWidth = 40.0;

  @override
  void initState() {
    super.initState();

    _selectedHeight = widget.initialHeight;

    final initialOffset = (_selectedHeight - widget.minHeight) * _itemWidth;

    _scrollController = ScrollController(initialScrollOffset: initialOffset);

    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant HeightSliderCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialHeight != widget.initialHeight &&
        widget.initialHeight != _selectedHeight) {
      _selectedHeight = widget.initialHeight;

      final targetOffset = (_selectedHeight - widget.minHeight) * _itemWidth;

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(targetOffset);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final offset = _scrollController.offset;

    final index = (offset / _itemWidth).round();

    final newHeight = (widget.minHeight + index).clamp(
      widget.minHeight,
      widget.maxHeight,
    );

    if (newHeight != _selectedHeight) {
      setState(() {
        _selectedHeight = newHeight;
      });

      widget.onChanged(newHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.maxHeight - widget.minHeight + 1;

    return Container(
      width: double.infinity,
      height: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),

      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // =====================================
          // Title
          // =====================================
          const Text(
            'Height (in cm)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // =====================================
          // Scrollable Ruler
          // =====================================
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final paddingLeftRight =
                    constraints.maxWidth / 2 - _itemWidth / 2;

                return ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),

                  padding: EdgeInsets.symmetric(horizontal: paddingLeftRight),

                  itemCount: totalItems,

                  itemBuilder: (context, index) {
                    final heightValue = widget.minHeight + index;

                    final isSelected = heightValue == _selectedHeight;

                    return SizedBox(
                      width: _itemWidth,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          // =================================
                          // Height Value
                          // =================================
                          SizedBox(
                            height: 28,

                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,

                                child: Text(
                                  '$heightValue',

                                  maxLines: 1,

                                  softWrap: false,

                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white38,

                                    fontSize: isSelected ? 20 : 10,

                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // =================================
                          // Tick
                          // =================================
                          Container(
                            width: isSelected ? 3.0 : 1.5,

                            height: isSelected ? 30.0 : 22.0,

                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.white30,

                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
