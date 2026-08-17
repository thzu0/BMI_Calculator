import 'package:bmi_v2/screen/activity.dart';
import 'package:bmi_v2/screen/profile.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({super.key});

  static const Color blue = Color(0xFF3B6FE0);

  Widget _navItem({
    required IconData icon,
    required String label,
    required VoidCallback onpressed,
  }) {
    return InkWell(
      onTap: onpressed,
      borderRadius: BorderRadius.circular(16.0),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 30),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: BottomAppBar(
        height: 100,
        color: blue,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          children: [
            Expanded(
              child: _navItem(
                icon: Icons.show_chart,
                label: 'Activity',
                onpressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BmiProgressChart()),
                  );
                },
              ),
            ),
            const SizedBox(width: 70),
            Expanded(
              child: _navItem(
                icon: Icons.person_outlined,
                label: 'Profile',
                onpressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
