import '../database/bmi_fields.dart';

class BmiMeasurement {
  final int? id;

  final String gender;

  final int height;
  final double weight;
  final int age;

  final double bmi;
  final double bodyFat;
  final double bmr;
  final int dailyCalories;

  final DateTime measuredAt;

  const BmiMeasurement({
    this.id,
    required this.gender,
    required this.height,
    required this.weight,
    required this.age,
    required this.bmi,
    required this.bodyFat,
    required this.bmr,
    required this.dailyCalories,
    required this.measuredAt,
  });

  // ==========================================
  // تبدیل Model به Map برای SQLite
  // ==========================================

  Map<String, Object?> toMap() {
    return {
      BmiFields.id: id,
      BmiFields.gender: gender,
      BmiFields.height: height,
      BmiFields.weight: weight,
      BmiFields.age: age,
      BmiFields.bmi: bmi,
      BmiFields.bodyFat: bodyFat,
      BmiFields.bmr: bmr,
      BmiFields.dailyCalories: dailyCalories,
      BmiFields.measuredAt: measuredAt.toIso8601String(),
    };
  }

  // ==========================================
  // ساخت Model از Map دیتابیس
  // ==========================================

  factory BmiMeasurement.fromMap(Map<String, Object?> map) {
    return BmiMeasurement(
      id: map[BmiFields.id] as int?,
      gender: map[BmiFields.gender] as String,
      height: map[BmiFields.height] as int,
      weight: (map[BmiFields.weight] as num).toDouble(),
      age: map[BmiFields.age] as int,
      bmi: (map[BmiFields.bmi] as num).toDouble(),
      bodyFat: (map[BmiFields.bodyFat] as num).toDouble(),
      bmr: (map[BmiFields.bmr] as num).toDouble(),
      dailyCalories: map[BmiFields.dailyCalories] as int,
      measuredAt: DateTime.parse(map[BmiFields.measuredAt] as String),
    );
  }

  // ==========================================
  // ساخت نسخه جدید با ID جدید
  // ==========================================

  BmiMeasurement copy({
    int? id,
    String? gender,
    int? height,
    double? weight,
    int? age,
    double? bmi,
    double? bodyFat,
    double? bmr,
    int? dailyCalories,
    DateTime? measuredAt,
  }) {
    return BmiMeasurement(
      id: id ?? this.id,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      bmi: bmi ?? this.bmi,
      bodyFat: bodyFat ?? this.bodyFat,
      bmr: bmr ?? this.bmr,
      dailyCalories: dailyCalories ?? this.dailyCalories,
      measuredAt: measuredAt ?? this.measuredAt,
    );
  }

  @override
  String toString() {
    return 'BmiMeasurement('
        'id: $id, '
        'gender: $gender, '
        'height: $height, '
        'weight: $weight, '
        'age: $age, '
        'bmi: $bmi, '
        'bodyFat: $bodyFat, '
        'bmr: $bmr, '
        'dailyCalories: $dailyCalories, '
        'measuredAt: $measuredAt'
        ')';
  }
}
