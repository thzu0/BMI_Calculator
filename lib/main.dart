import 'package:bmi_v2/screen/homescreen_normal_phone.dart';
import 'package:bmi_v2/screen/homescreen_small_phone.dart';
import 'package:flutter/material.dart';
import 'package:bmi_v2/bottom/bmi_result_card.dart';
import 'package:bmi_v2/bottom/bottomnv.dart';
import 'package:bmi_v2/database/bmi_database.dart';
import 'package:bmi_v2/models/bmi_measurement.dart';
import 'models/gender.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ==========================================================
  // Current User Inputs
  // ==========================================================

  Gender? _selectedGender;

  int _currentHeight = 172;
  int _currentWeight = 58;
  int _currentAge = 22;

  bool _isLoading = false;

  // ==========================================================
  // BMI Calculation + Save To Database
  // ==========================================================

  Future<void> handleCenterButtonTap() async {
    // جلوگیری از چندبار کلیک همزمان
    if (_isLoading) return;

    // ========================================================
    // بررسی جنسیت
    // ========================================================

    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لطفاً ابتدا جنسیت خود را انتخاب کنید!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    // ========================================================
    // شروع Loading
    // ========================================================

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    // ========================================================
    // BMI
    // ========================================================

    final heightInMeters = _currentHeight / 100;

    final bmi = _currentWeight / (heightInMeters * heightInMeters);

    // ========================================================
    // Gender Value
    // ========================================================

    final genderValue = (_selectedGender == Gender.male) ? 1 : 0;

    // ========================================================
    // Body Fat
    // ========================================================

    double fat =
        (1.20 * bmi) + (0.23 * _currentAge) - (10.8 * genderValue) - 5.4;

    if (fat < 0) {
      fat = 0;
    }

    // ========================================================
    // BMR
    // ========================================================

    double bmr =
        (10 * _currentWeight) + (6.25 * _currentHeight) - (5 * _currentAge);

    if (_selectedGender == Gender.male) {
      bmr += 5;
    } else {
      bmr -= 161;
    }

    // ========================================================
    // Daily Calories
    // ========================================================

    final calories = (bmr * 1.2).round();

    // ========================================================
    // Save Measurement To SQLite
    // ========================================================

    try {
      final measurement = BmiMeasurement(
        gender: _selectedGender == Gender.male ? 'male' : 'female',

        height: _currentHeight,

        weight: _currentWeight.toDouble(),

        age: _currentAge,

        bmi: bmi,

        bodyFat: fat,

        bmr: bmr,

        dailyCalories: calories,

        measuredAt: DateTime.now(),
      );

      final savedMeasurement = await BmiDatabase.instance.createMeasurement(
        measurement,
      );

      debugPrint('BMI measurement saved successfully.');

      debugPrint('Measurement ID: ${savedMeasurement.id}');
    } catch (e, stackTrace) {
      debugPrint('Database error: $e');

      debugPrint(stackTrace.toString());

      // فعلاً اجازه می‌دهیم Result Card
      // حتی در صورت خطای Database نمایش داده شود.
      //
      // بعداً می‌توانیم تصمیم بگیریم که
      // در صورت خطا اصلاً نتیجه نمایش داده نشود.
    }

    // ========================================================
    // Stop Loading
    // ========================================================

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    // ========================================================
    // Show Result Bottom Sheet
    // ========================================================

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return BmiResultCard(
          bmiResult: bmi,
          bodyFatResult: fat,
          dailyCalories: calories,
          isMale: _selectedGender == Gender.male,
        );
      },
    );

    // ========================================================
    // Reset Inputs
    // ========================================================

    if (!mounted) return;

    setState(() {
      _selectedGender = null;

      _currentHeight = 172;

      _currentWeight = 58;

      _currentAge = 22;
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isTablet = size.width > 600;

    return Scaffold(
      extendBody: true,

      backgroundColor: const Color(0xFF0F1429),

      // ======================================================
      // BODY
      // ======================================================
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? size.width * 0.15 : 20,
          ),

          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmallScreen = constraints.maxHeight < 600;

              // ==================================================
              // SMALL SCREEN
              // ==================================================

              if (isSmallScreen) {
                return HomeSmallScreen(
                  selectedGender: _selectedGender,

                  currentHeight: _currentHeight,

                  currentWeight: _currentWeight,

                  currentAge: _currentAge,

                  onGenderChanged: (gender) {
                    setState(() {
                      _selectedGender = gender;
                    });
                  },

                  onHeightChanged: (value) {
                    setState(() {
                      _currentHeight = value;
                    });
                  },

                  onWeightChanged: (value) {
                    setState(() {
                      _currentWeight = value;
                    });
                  },

                  onAgeChanged: (value) {
                    setState(() {
                      _currentAge = value;
                    });
                  },
                );
              }

              // ==================================================
              // LARGE / NORMAL SCREEN
              // ==================================================

              return HomeLargeScreen(
                selectedGender: _selectedGender,

                currentHeight: _currentHeight,

                currentWeight: _currentWeight,

                currentAge: _currentAge,

                availableHeight: constraints.maxHeight,

                availableWidth: constraints.maxWidth,

                onGenderChanged: (gender) {
                  setState(() {
                    _selectedGender = gender;
                  });
                },

                onHeightChanged: (value) {
                  setState(() {
                    _currentHeight = value;
                  });
                },

                onWeightChanged: (value) {
                  setState(() {
                    _currentWeight = value;
                  });
                },

                onAgeChanged: (value) {
                  setState(() {
                    _currentAge = value;
                  });
                },
              );
            },
          ),
        ),
      ),

      // ======================================================
      // FLOATING ACTION BUTTON
      // ======================================================
      floatingActionButton: FloatingActionButton(
        onPressed: handleCenterButtonTap,

        backgroundColor: Colors.white,

        elevation: 5,

        shape: const CircleBorder(
          side: BorderSide(width: 1.5, color: Colors.blueAccent),
        ),

        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,

                child: CircularProgressIndicator(
                  color: Color(0xFF3B6FE0),
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'BMI',

                style: TextStyle(
                  color: Color(0xFF3B6FE0),

                  fontWeight: FontWeight.bold,

                  fontSize: 13,
                ),
              ),
      ),

      // ======================================================
      // FLOATING BUTTON LOCATION
      // ======================================================
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ======================================================
      // BOTTOM NAVIGATION
      // ======================================================
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
