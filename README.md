# ⚖️ BMI Calculator

A modern **BMI, Body Fat, BMR, and Daily Calorie Calculator** built with **Flutter** and **Dart**.

The application allows users to enter their gender, height, weight, and age, then calculates several body-related metrics and stores measurement history locally.

## ✨ Features

* ⚖️ Calculate **BMI (Body Mass Index)**
* 🧍 Calculate estimated **Body Fat Percentage**
* 🔥 Calculate **BMR (Basal Metabolic Rate)**
* 🍽️ Estimate **Daily Calorie Needs**
* 👨 Male / 👩 Female input
* 📏 Height selection
* ⚖️ Weight selection
* 🎂 Age selection
* 💾 Save measurements locally
* 📊 View calculated results in a bottom sheet
* 📱 Responsive layout for different screen sizes
* 📐 Separate layouts for small and normal/large screens
* ⏳ Loading state during calculation
* 🧭 Custom bottom navigation

## 🧮 Calculations

### BMI

BMI is calculated using:

```text
BMI = weight / height²
```

where height is converted from centimeters to meters.

### Body Fat

The application uses an estimation formula based on BMI, age, and gender:

```text
Body Fat =
(1.20 × BMI)
+ (0.23 × Age)
- (10.8 × Gender)
- 5.4
```

The calculated value is prevented from becoming negative.

### BMR

BMR is calculated using the **Mifflin-St Jeor equation**:

```text
Male:
BMR = 10W + 6.25H - 5A + 5

Female:
BMR = 10W + 6.25H - 5A - 161
```

Where:

* `W` = Weight in kilograms
* `H` = Height in centimeters
* `A` = Age in years

### Daily Calories

The current application estimates daily calorie needs using:

```text
Daily Calories = BMR × 1.2
```

This corresponds to a sedentary activity multiplier.

## 🛠️ Built With

* **Flutter**
* **Dart**
* **SQLite**
* **sqflite** — Local database
* **fl_chart** — Charts and data visualization
* **flutter_scale_ruler** — Scale/ruler input
* **path** — File/database path handling

## 🏗️ Project Structure

```text
lib/
├── bottom/
│   ├── bmi_result_card.dart
│   └── bottomnv.dart
│
├── database/
│   └── bmi_database.dart
│
├── models/
│   ├── bmi_measurement.dart
│   └── gender.dart
│
├── screen/
│   ├── homescreen_normal_phone.dart
│   └── homescreen_small_phone.dart
│
└── main.dart
```

## 💾 Local Database

BMI measurements are stored locally using **SQLite**.

Each saved measurement contains information such as:

* Gender
* Height
* Weight
* Age
* BMI
* Body Fat
* BMR
* Daily Calories
* Measurement date

This allows the application to maintain a local history of measurements without requiring an online backend.

## 📱 Responsive Design

The application adapts its interface according to the available screen size.

Small-screen devices use a dedicated layout, while larger/normal phone screens use a different layout optimized for the available space.

## 🚀 Getting Started

### Prerequisites

Install:

* Flutter SDK
* Dart SDK
* Android Studio or another Flutter-compatible IDE
* Android SDK for Android builds

### Installation

Clone the repository:

```bash
git clone https://github.com/thzu0/BMI_Calculator.git
```

Enter the project directory:

```bash
cd BMI_Calculator
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## 📦 Build APK

Build a release APK:

```bash
flutter build apk --release
```

Or generate APKs for different CPU architectures:

```bash
flutter build apk --split-per-abi
```

## ⚠️ Disclaimer

The calculations provided by this application are **estimates for informational purposes** and should not be considered medical advice or a professional health assessment.

## 📊 Project Status

🚧 **In Development**

The project may receive additional features, UI improvements, and calculation/history enhancements.

## 👨‍💻 Author

**thzu0**

GitHub: https://github.com/thzu0

## 📄 License

This project is currently provided for educational and personal development purposes.
