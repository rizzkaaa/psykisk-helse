import 'quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:uas_project/widgets/unstyle_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class CardList extends StatelessWidget {
  final dynamic test;
  const CardList({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Color(0xFF6B8E7B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Text(
                    test['emoji'],
                    style: const TextStyle(fontSize: 32),
                  ),
                ),

                title: Text(
                  test['title'],
                  style: GoogleFonts.modernAntiqua(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  test['subtitle'],
                  style: GoogleFonts.bricolageGrotesque(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              UnstyleButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => QuizScreen(testData: test)),
                ),
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
                    "Start Test",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
