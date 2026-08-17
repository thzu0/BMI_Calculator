import 'package:flutter/material.dart';
import '../models/gender.dart';

class GenderSelector extends StatelessWidget {
  final Gender? selectedGender;
  final ValueChanged<Gender?>? onChanged;

  const GenderSelector({super.key, this.selectedGender, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _GenderCard(
            gender: Gender.male,
            label: 'Male',
            icon: Icons.male,
            iconColor: Colors.deepOrange,
            isSelected: selectedGender == Gender.male,
            onTap: () => onChanged?.call(Gender.male),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _GenderCard(
            gender: Gender.female,
            label: 'Female',
            icon: Icons.female,
            iconColor: Colors.pinkAccent,
            isSelected: selectedGender == Gender.female,
            onTap: () => onChanged?.call(Gender.female),
          ),
        ),
      ],
    );
  }
}

class _GenderCard extends StatelessWidget {
  final Gender gender;
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.gender,
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // اصلاح به milliseconds
        height: 200,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey[800] : Colors.grey[500],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.white70 : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 100, color: iconColor),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
