import 'package:bmi_v2/models/gender.dart';
import 'package:bmi_v2/slider/height_slider.dart';
import 'package:bmi_v2/widget/selector_gender.dart';
import 'package:flutter/material.dart';
import 'package:bmi_v2/slider/age_slider.dart';
import 'package:bmi_v2/slider/wieght_slider.dart';

class HomeLargeScreen extends StatelessWidget {
  final Gender? selectedGender;
  final int currentHeight;
  final int currentWeight;
  final int currentAge;
  final double availableHeight;
  final double availableWidth;
  final ValueChanged<Gender?> onGenderChanged;
  final ValueChanged<int> onHeightChanged;
  final ValueChanged<int> onWeightChanged;
  final ValueChanged<int> onAgeChanged;

  const HomeLargeScreen({
    super.key,
    required this.selectedGender,
    required this.currentHeight,
    required this.currentWeight,
    required this.currentAge,
    required this.availableHeight,
    required this.availableWidth,
    required this.onGenderChanged,
    required this.onHeightChanged,
    required this.onWeightChanged,
    required this.onAgeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final gap = availableHeight * 0.02;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BMI Calculator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: gap),

        // انتخاب جنسیت
        Expanded(
          flex: 3,
          child: GenderSelector(
            selectedGender: selectedGender,
            onChanged: onGenderChanged,
          ),
        ),
        SizedBox(height: gap),

        // انتخاب قد
        Expanded(
          flex: 3,
          child: HeightSliderCard(
            initialHeight: currentHeight,
            minHeight: 140,
            maxHeight: 210,
            onChanged: onHeightChanged,
          ),
        ),
        SizedBox(height: gap),

        // انتخاب وزن و سن
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Expanded(child: WeightSlider(onChanged: onWeightChanged)),
              SizedBox(width: availableWidth * 0.04),
              Expanded(
                child: AgeSlider(
                  initialAge: currentAge,
                  onChanged: onAgeChanged,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: availableHeight * 0.08),
      ],
    );
  }
}
