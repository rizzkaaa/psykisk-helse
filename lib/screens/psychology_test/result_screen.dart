import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_project/widgets/unstyle_button.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class ResultScreen extends StatelessWidget {
  final int score;
  const ResultScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    int status = score < 10
        ? 2
        : score < 20
        ? 1
        : 0;
    Map<String, String> result = {
      "Stable":
          "Your psychological condition appears stable. You are managing your thoughts and emotions well at this time.",
      "Mild":
          "You may be experiencing mild psychological distress. This could affect your mood or focus, but it is generally manageable.",
      "Severe":
          "You may be experiencing significant psychological distress. This may impact your daily functioning and well-being.",
    };

    String level = result.keys.elementAt(status);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your test analysis results:",
              style: GoogleFonts.modernAntiqua(
                color: Color(0xFF73a664),
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
            ),
            Text(
              level,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5C8374),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "${result[level]!} but remember! This result is not a medical diagnosis. For professional advice, consider consulting a qualified mental health professional.",
                style: GoogleFonts.bricolageGrotesque(
                  // fontSize: 20,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: UnstyleButton(
                onPressed: () => Navigator.pushNamed(context, "/homeScreen"),
                content: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: inset.BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      inset.BoxShadow(
                        color: Colors.white10.withOpacity(0.3),
                        blurRadius: 2,
                        offset: Offset(2, 0),
                        inset: true,
                      ),
                      inset.BoxShadow(
                        color: Colors.white10.withOpacity(0.3),
                        blurRadius: 2,
                        offset: Offset(-2, 0),
                        inset: true,
                      ),
                    ],
                    color: Color(0xFF8BAA9B),
                  ),
                  child: const Text(
                    "Back to Homescreen",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
