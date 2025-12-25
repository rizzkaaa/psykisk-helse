import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:google_fonts/google_fonts.dart';

class TabMenuHome extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String title;
  final String? titleOpsional;

  const TabMenuHome({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.titleOpsional,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        overlayColor: Colors.transparent,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: inset.BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFF4A7C7E),
              boxShadow: [
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(2, 0),
                  inset: true,
                ),
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(-2, 0),
                  inset: true,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),

          Text(
            title,
            style: GoogleFonts.bricolageGrotesque(color: Color(0xFF4A7C7E)),
          ),
          if (titleOpsional != null)
            Text(
              titleOpsional!,
              style: GoogleFonts.bricolageGrotesque(color: Color(0xFF4A7C7E)),
            ),
        ],
      ),
    );
  }
}
