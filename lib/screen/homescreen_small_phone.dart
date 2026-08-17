import 'package:bmi_v2/models/gender.dart';
import 'package:bmi_v2/slider/height_slider.dart';
import 'package:bmi_v2/widget/selector_gender.dart';
import 'package:flutter/material.dart';
import 'package:bmi_v2/slider/age_slider.dart';
import 'package:bmi_v2/slider/wieght_slider.dart';

class HomeSmallScreen extends StatelessWidget {
  final Gender? selectedGender;
  final int currentHeight;
  final int currentWeight;
  final int currentAge;
  final ValueChanged<Gender?> onGenderChanged;
  final ValueChanged<int> onHeightChanged;
  final ValueChanged<int> onWeightChanged;
  final ValueChanged<int> onAgeChanged;

  const HomeSmallScreen({
    super.key,
    required this.selectedGender,
    required this.currentHeight,
    required this.currentWeight,
    required this.currentAge,
    required this.onGenderChanged,
    required this.onHeightChanged,
    required this.onWeightChanged,
    required this.onAgeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            'BMI Calculator',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // انتخاب جنسیت
          SizedBox(
            height: 150,
            child: GenderSelector(
              selectedGender: selectedGender,
              onChanged: onGenderChanged,
            ),
          ),
          const SizedBox(height: 16),

          // انتخاب قد
          SizedBox(
            height: 180,
            child: HeightSliderCard(
              initialHeight: currentHeight,
              minHeight: 140,
              maxHeight: 210,
              onChanged: onHeightChanged,
            ),
          ),
          const SizedBox(height: 16),

          // انتخاب وزن و سن
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(child: WeightSlider(onChanged: onWeightChanged)),
                const SizedBox(width: 16),
                Expanded(
                  child: AgeSlider(
                    initialAge: currentAge,
                    onChanged: onAgeChanged,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // فضای خالی برای نیفتادن روی دکمه شناور
        ],
      ),
    );
  }
}
