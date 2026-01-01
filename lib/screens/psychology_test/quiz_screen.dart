import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uas_project/services/mood_tracker_service.dart';
import 'waiting_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class QuizScreen extends StatefulWidget {
  final dynamic testData;
  const QuizScreen({super.key, required this.testData});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final MoodTrackerService _moodTrackerService = MoodTrackerService();

  int currentIndex = 0;
  int totalScore = 0;
  double _manualValue = 2;

  void _next(int score) {
    totalScore += score;
    if (currentIndex < widget.testData['questions'].length - 1) {
      setState(() => currentIndex++);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WaitingScreen(score: totalScore)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.testData['questions'][currentIndex];
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4DD),
      appBar: AppBar(
        backgroundColor: Color(0xFF73a664),
        leading: SizedBox(),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        actions: [
          Container(
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
              color: Colors.white,
            ),
            child: IconButton(
              icon: const Icon(Icons.reply, color: Color(0xFF73a664)),
              onPressed: () => Navigator.pop(context),
              tooltip: "Back",
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                decoration: inset.BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                  color: Color(0xFF73a664),
                  boxShadow: [
                    inset.BoxShadow(
                      color: Colors.black45.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(2, 0),
                      inset: false,
                    ),
                    inset.BoxShadow(
                      color: Colors.black45.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(-2, 0),
                      inset: false,
                    ),
                    inset.BoxShadow(
                      color: Colors.black45.withOpacity(0.5),
                      blurRadius: 2,
                      offset: Offset(0, -2),
                      inset: true,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.psychology, color: Colors.white, size: 40),
                    const SizedBox(width: 8),
                    Text(
                      widget.testData["title"],
                      style: GoogleFonts.modernAntiqua(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  "$currentIndex / 10",
                  style: GoogleFonts.modernAntiqua(
                    color: Color(0xFF73a664),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: (currentIndex + 1) / 10,color: Color(0xFF5C8374), borderRadius: BorderRadius.circular(20),),
                const SizedBox(height: 30),
                Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          question['text'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15),
                        Lottie.asset(
                          "assets/animation/${_moodTrackerService.moodData[_manualValue.toInt()]['lottie']}",
                          height: 100,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          question['options'][_manualValue.toInt()],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Slider(
                          value: _manualValue,
                          min: 0,
                          max: 4,
                          divisions: 4,
                          activeColor: Color(0xFF5C8374),
                          onChanged: (value) {
                            setState(() {
                              _manualValue = value;
                              _next(_manualValue.toInt());
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
