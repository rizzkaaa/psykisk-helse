import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:google_fonts/google_fonts.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;
  const ConfirmDialog({super.key, required this.title, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        decoration: inset.BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
          color: Color(0xFF6B8E7B),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Confirm:",
              style: GoogleFonts.modernAntiqua(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.white70,
              radius: BorderRadius.circular(20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                title,
                style: GoogleFonts.bricolageGrotesque(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "No",
                      style: GoogleFonts.bricolageGrotesque(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(0, 0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                  ),
                  onPressed: onConfirm,
                  child: Text(
                    "Confirm",
                    style: GoogleFonts.bricolageGrotesque(
                      color: Color(0xFF6B8E7B),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
