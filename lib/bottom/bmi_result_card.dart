import 'package:flutter/material.dart';

class BmiResultCard extends StatelessWidget {
  final double bmiResult;
  final double bodyFatResult;
  final int dailyCalories;
  final bool isMale;

  const BmiResultCard({
    super.key,
    required this.bmiResult,
    required this.bodyFatResult,
    required this.dailyCalories,
    required this.isMale,
  });

  static const Color blue = Color(0xFF3B6FE0);

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal Weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  String _getBodyFatCategory(double fat, bool isMale) {
    if (isMale) {
      if (fat < 6) return 'Essential Fat';
      if (fat < 14) return 'Athletes';
      if (fat < 18) return 'Fitness';
      if (fat < 25) return 'Average';
      return 'High Fat';
    } else {
      if (fat < 14) return 'Essential Fat';
      if (fat < 21) return 'Athletes';
      if (fat < 25) return 'Fitness';
      if (fat < 32) return 'Average';
      return 'High Fat';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bmiCategory = _getBmiCategory(bmiResult);
    final fatCategory = _getBodyFatCategory(bodyFatResult, isMale);

    return Container(
      height: 400,
      decoration: const BoxDecoration(
        color: blue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            'Your Health Metrics',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ResultTile(
                title: 'BMI',
                value: bmiResult.toStringAsFixed(1),
                unit: 'kg/m²',
                category: bmiCategory,
              ),
              Container(height: 45, width: 1, color: Colors.white30),
              _ResultTile(
                title: 'Body Fat',
                value: bodyFatResult.toStringAsFixed(1),
                unit: '%',
                category: fatCategory,
              ),
              Container(height: 45, width: 1, color: Colors.white30),
              _ResultTile(
                title: 'Daily Calories',
                value: '$dailyCalories',
                unit: 'kcal',
                category: 'Maintenance',
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '• BMI: ${bmiResult.toStringAsFixed(1)} ($bmiCategory)\n'
              '• Estimated Body Fat: ${bodyFatResult.toStringAsFixed(1)}% ($fatCategory)\n'
              '• Recommended Daily Calories: ~$dailyCalories kcal/day to maintain current weight.',
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border, color: Colors.white),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String category;

  const _ResultTile({
    required this.title,
    required this.value,
    required this.unit,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          category,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
