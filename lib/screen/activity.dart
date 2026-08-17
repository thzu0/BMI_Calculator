import 'package:bmi_v2/database/bmi_database.dart';
import 'package:bmi_v2/models/bmi_measurement.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color contentColorRed = Color(0xFFE57373);
  static const Color contentColorYellow = Color(0xFFFFC107);
  static const Color contentColorGreen = Color(0xFF4CAF50);
  static const Color contentColorOrange = Color(0xFFFF9800);
  static const Color contentColorBlue = Color(0xFF2196F3);

  static const Color mainTextColor1 = Colors.white;
  static const Color mainGridLineColor = Color(0xFFD3D3D3);
  static const Color borderColor = Color(0xFFB2B2B2);
}

class BmiProgressChart extends StatefulWidget {
  BmiProgressChart({
    super.key,
    Color? lineColor,
    Color? indicatorLineColor,
    Color? indicatorTouchedLineColor,
    Color? indicatorSpotStrokeColor,
    Color? indicatorTouchedSpotStrokeColor,
    Color? bottomTextColor,
    Color? bottomTouchedTextColor,
    Color? averageLineColor,
    Color? tooltipBgColor,
    Color? tooltipTextColor,
  }) : lineColor = lineColor ?? AppColors.contentColorBlue,
       indicatorLineColor =
           indicatorLineColor ??
           AppColors.contentColorBlue.withValues(alpha: 0.2),
       indicatorTouchedLineColor =
           indicatorTouchedLineColor ?? AppColors.contentColorBlue,
       indicatorSpotStrokeColor =
           indicatorSpotStrokeColor ??
           AppColors.contentColorBlue.withValues(alpha: 0.5),
       indicatorTouchedSpotStrokeColor =
           indicatorTouchedSpotStrokeColor ?? AppColors.contentColorBlue,
       bottomTextColor =
           bottomTextColor ?? AppColors.mainTextColor1.withValues(alpha: 0.5),
       bottomTouchedTextColor =
           bottomTouchedTextColor ?? AppColors.mainTextColor1,
       averageLineColor =
           averageLineColor ??
           AppColors.contentColorGreen.withValues(alpha: 0.8),
       tooltipBgColor = tooltipBgColor ?? AppColors.contentColorBlue,
       tooltipTextColor = tooltipTextColor ?? Colors.white;

  final Color lineColor;
  final Color indicatorLineColor;
  final Color indicatorTouchedLineColor;
  final Color indicatorSpotStrokeColor;
  final Color indicatorTouchedSpotStrokeColor;
  final Color bottomTextColor;
  final Color bottomTouchedTextColor;
  final Color averageLineColor;
  final Color tooltipBgColor;
  final Color tooltipTextColor;

  @override
  State<BmiProgressChart> createState() => _BmiProgressChartState();
}

class _BmiProgressChartState extends State<BmiProgressChart> {
  late double touchedValue;

  bool fitInsideBottomTitle = false;
  bool fitInsideLeftTitle = false;

  // =========================================================
  // DATABASE DATA
  // =========================================================

  List<BmiMeasurement> _measurements = [];
  bool _isLoadingData = true;

  // =========================================================
  // BMI VALUES FOR CHART
  // =========================================================

  List<double> get bmiValues {
    return _measurements.map((measurement) => measurement.bmi).toList();
  }

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    touchedValue = -1;

    _loadMeasurements();
  }

  // =========================================================
  // LOAD DATABASE
  // =========================================================

  Future<void> _loadMeasurements() async {
    try {
      final measurements = await BmiDatabase.instance.readLast30Measurements();

      if (!mounted) return;

      setState(() {
        _measurements = measurements;
        _isLoadingData = false;
      });
    } catch (e, stackTrace) {
      debugPrint('Activity database error: $e');
      debugPrint(stackTrace.toString());

      if (!mounted) return;

      setState(() {
        _measurements = [];
        _isLoadingData = false;
      });
    }
  }

  // =========================================================
  // DATE FORMAT
  // =========================================================

  String _formatDate(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }

    final yesterday = now.subtract(const Duration(days: 1));

    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  // =========================================================
  // BMI CHANGE
  // =========================================================

  String _getBmiChangeText(double currentBmi, double? previousBmi) {
    if (previousBmi == null) {
      return '—';
    }

    final change = currentBmi - previousBmi;

    if (change > 0) {
      return '▲${change.toStringAsFixed(1)}';
    }

    if (change < 0) {
      return '▼${change.abs().toStringAsFixed(1)}';
    }

    return '0.0';
  }

  // =========================================================
  // BMI CATEGORY
  // =========================================================

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) {
      return 'Underweight';
    }

    if (bmi < 25) {
      return 'Normal';
    }

    if (bmi < 30) {
      return 'Overweight';
    }

    return 'Obese';
  }

  // =========================================================
  // LEFT TITLES
  // =========================================================

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value % 5 != 0) {
      return const SizedBox.shrink();
    }

    final style = TextStyle(
      color: AppColors.mainTextColor1.withValues(alpha: 0.5),
      fontSize: 10,
    );

    return SideTitleWidget(
      meta: meta,
      space: 6,
      fitInside: fitInsideLeftTitle
          ? SideTitleFitInsideData.fromTitleMeta(meta)
          : SideTitleFitInsideData.disable(),
      child: Text(
        value.toInt().toString(),
        maxLines: 1,
        softWrap: false,
        style: style,
        textAlign: TextAlign.center,
      ),
    );
  }

  // =========================================================
  // BOTTOM TITLES
  // =========================================================

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (bmiValues.isEmpty) {
      return const SizedBox.shrink();
    }

    final day = value.round();

    if (day < 0 || day >= bmiValues.length) {
      return const SizedBox.shrink();
    }

    bool shouldShow = false;

    if (bmiValues.length <= 6) {
      shouldShow = day == 0 || day == bmiValues.length - 1;
    } else {
      shouldShow = day == 0 || day == bmiValues.length - 1 || day % 6 == 0;
    }

    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    final isTouched = value == touchedValue;

    return SideTitleWidget(
      meta: meta,
      space: 2,
      fitInside: SideTitleFitInsideData.disable(),
      child: Text(
        'Day ${day + 1}',
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          color: isTouched
              ? widget.bottomTouchedTextColor
              : widget.bottomTextColor,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }

  // =========================================================
  // HISTORY CARD
  // =========================================================

  Widget _buildHistoryCard({
    required BmiMeasurement measurement,
    BmiMeasurement? previousMeasurement,
  }) {
    final dateText = _formatDate(measurement.measuredAt);

    final bmiCategory = _getBmiCategory(measurement.bmi);

    final bmiChange = _getBmiChangeText(
      measurement.bmi,
      previousMeasurement?.bmi,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF101A2C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1F2C46), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // =====================================================
          // GREEN DOT
          // =====================================================
          Container(
            width: 9,
            height: 9,
            decoration: const BoxDecoration(
              color: Color(0xFF34D6A0),
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 10),

          // =====================================================
          // LEFT INFORMATION
          // =====================================================
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFEEF1F8),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Weight ${measurement.weight.toStringAsFixed(1)} kg  •  '
                    'Height ${measurement.height} cm',
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      color: Color(0xFF7C88A3),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // =====================================================
          // BMI
          // =====================================================
          SizedBox(
            width: 45,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    measurement.bmi.toStringAsFixed(1),
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      color: Color(0xFF34D6A0),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                const SizedBox(height: 2),

                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    bmiCategory,
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(
                      color: Color(0xFF7C88A3),
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // =====================================================
          // BADGE
          // =====================================================
          SizedBox(
            width: 40,
            height: 20,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF34D6A0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  bmiChange,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(
                    color: Color(0xFF0F1429),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        // =====================================================
        // APP BAR
        // =====================================================
        appBar: AppBar(
          title: const Text(
            'Activity',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF0F1429),
        ),

        backgroundColor: const Color(0xFF0F1429),

        // =====================================================
        // BODY
        // =====================================================
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // =================================================
              // TARGET BMI
              // =================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Target BMI (Normal)',
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // =================================================
              // CHART
              // =================================================
              AspectRatio(
                aspectRatio: 2,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 12),
                  child: LineChart(
                    LineChartData(
                      // =================================================
                      // X AXIS
                      // =================================================
                      minX: 0,
                      maxX: bmiValues.isEmpty
                          ? 1
                          : (bmiValues.length - 1).toDouble(),

                      // =================================================
                      // Y AXIS
                      // =================================================
                      minY: 15,
                      maxY: 35,

                      // =================================================
                      // TOUCH
                      // =================================================
                      lineTouchData: LineTouchData(
                        getTouchedSpotIndicator:
                            (LineChartBarData barData, List<int> spotIndexes) {
                              return spotIndexes.map((spotIndex) {
                                return TouchedSpotIndicatorData(
                                  FlLine(
                                    color: widget.indicatorTouchedLineColor,
                                    strokeWidth: 2,
                                    dashArray: [4, 4],
                                  ),
                                  FlDotData(
                                    getDotPainter:
                                        (spot, percent, barData, index) {
                                          return FlDotCirclePainter(
                                            radius: 6,
                                            color: Colors.white,
                                            strokeWidth: 3,
                                            strokeColor: widget
                                                .indicatorTouchedSpotStrokeColor,
                                          );
                                        },
                                  ),
                                );
                              }).toList();
                            },

                        // =================================================
                        // TOOLTIP
                        // =================================================
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) =>
                              widget.tooltipBgColor,
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              return LineTooltipItem(
                                'Day ${barSpot.x.toInt() + 1}\n',
                                TextStyle(
                                  color: widget.tooltipTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'BMI: ',
                                    style: TextStyle(
                                      color: widget.tooltipTextColor.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  TextSpan(
                                    text: barSpot.y.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: widget.tooltipTextColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              );
                            }).toList();
                          },
                        ),

                        // =================================================
                        // TOUCH CALLBACK
                        // =================================================
                        touchCallback:
                            (FlTouchEvent event, LineTouchResponse? lineTouch) {
                              if (!event.isInterestedForInteractions ||
                                  lineTouch == null ||
                                  lineTouch.lineBarSpots == null) {
                                setState(() {
                                  touchedValue = -1;
                                });
                                return;
                              }

                              setState(() {
                                touchedValue = lineTouch.lineBarSpots![0].x;
                              });
                            },
                      ),

                      // =================================================
                      // TARGET LINE
                      // =================================================
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: 22.0,
                            color: widget.averageLineColor,
                            strokeWidth: 2,
                            dashArray: [10, 5],
                            label: HorizontalLineLabel(
                              show: true,
                              alignment: Alignment.topRight,
                              padding: const EdgeInsets.only(
                                right: 5,
                                bottom: 5,
                              ),
                              style: TextStyle(
                                color: widget.averageLineColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              labelResolver: (line) => 'Target',
                            ),
                          ),
                        ],
                      ),

                      // =================================================
                      // LINE
                      // =================================================
                      lineBarsData: [
                        LineChartBarData(
                          isStepLineChart: false,
                          isCurved: true,
                          curveSmoothness: 0.2,
                          spots: bmiValues
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value))
                              .toList(),
                          barWidth: 4,
                          color: widget.lineColor,
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                widget.lineColor.withValues(alpha: 0.4),
                                widget.lineColor.withValues(alpha: 0.0),
                              ],
                              stops: const [0.0, 1.0],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          dotData: FlDotData(
                            show: true,
                            checkToShowDot: (spot, barData) {
                              return true;
                            },
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 3,
                                color: widget.lineColor,
                                strokeWidth: 1,
                                strokeColor: Colors.white,
                              );
                            },
                          ),
                        ),
                      ],

                      // =================================================
                      // BORDER
                      // =================================================
                      borderData: FlBorderData(
                        show: true,
                        border: const Border(
                          bottom: BorderSide(color: AppColors.borderColor),
                          left: BorderSide(color: AppColors.borderColor),
                          right: BorderSide(color: Colors.transparent),
                          top: BorderSide(color: Colors.transparent),
                        ),
                      ),

                      // =================================================
                      // GRID
                      // =================================================
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        drawVerticalLine: true,
                        checkToShowHorizontalLine: (value) => value % 5 == 0,
                        checkToShowVerticalLine: (value) => value % 5 == 0,
                        getDrawingHorizontalLine: (value) {
                          return const FlLine(
                            color: AppColors.mainGridLineColor,
                            strokeWidth: 0.5,
                          );
                        },
                        getDrawingVerticalLine: (value) {
                          return const FlLine(
                            color: AppColors.mainGridLineColor,
                            strokeWidth: 0.5,
                            dashArray: [4, 4],
                          );
                        },
                      ),

                      // =================================================
                      // TITLES
                      // =================================================
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            getTitlesWidget: leftTitleWidgets,
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 25,
                            interval: 1,
                            getTitlesWidget: bottomTitleWidgets,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 55),

              // =================================================
              // HISTORY TITLE
              // =================================================
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF34D6A0),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      'History',
                      maxLines: 1,
                      style: TextStyle(
                        color: Color(0xFFEEF1F8),
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // =================================================
              // HISTORY LIST
              // =================================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _isLoadingData
                    ? const SizedBox(
                        height: 120,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : _measurements.isEmpty
                    ? const SizedBox(
                        height: 120,
                        child: Center(
                          child: Text(
                            'No measurements yet.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: List.generate(_measurements.length, (index) {
                          final reversedIndex =
                              _measurements.length - 1 - index;

                          final measurement = _measurements[reversedIndex];

                          BmiMeasurement? previousMeasurement;

                          if (reversedIndex - 1 >= 0) {
                            previousMeasurement =
                                _measurements[reversedIndex - 1];
                          }

                          return _buildHistoryCard(
                            measurement: measurement,
                            previousMeasurement: previousMeasurement,
                          );
                        }),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
