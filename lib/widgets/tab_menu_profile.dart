import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabMenuProfile extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final bool isActive;

  const TabMenuProfile({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        decoration: BoxDecoration(
          color: isActive ? Color(0xFF4A7C7E) : Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFF4A7C7E)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? Colors.white : Color(0xFF4A7C7E)),
            const SizedBox(width: 5),
            Text(
              label,
              style: GoogleFonts.bricolageGrotesque(
                color: isActive ? Colors.white : Color(0xFF4A7C7E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
