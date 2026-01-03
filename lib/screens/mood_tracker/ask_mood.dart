import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/models/mood_model.dart';
import 'package:uas_project/screens/mood_tracker/card_question.dart';

import 'package:uas_project/services/mood_tracker_service.dart';

class AskMood extends StatefulWidget {
  const AskMood({super.key});

  @override
  State<AskMood> createState() => _AskMoodState();
}

class _AskMoodState extends State<AskMood> {
  final MoodTrackerService _moodTrackerService = MoodTrackerService();
  List<MoodQuestion> _questions = [];
  final Map<String, MoodOption> _selectedAnswers = {};
  bool _isLoading = true;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await _moodTrackerService.loadQuestions();
    setState(() {
      _questions = questions;
      _isLoading = false;
    });
  }

  double _calculateAvgScore() {
    return _moodTrackerService.calculateAvgScore(
      _selectedAnswers,
      _questions.length,
    );
  }

  Future<void> _submitData(String idUser) async {
    if (_selectedAnswers.length < _questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complete al the indicator!")),
      );
      return;
    }

    double avgScore = _calculateAvgScore();
    final moodData = _moodTrackerService.moodData[avgScore.toInt()];

    try {
      await _moodTrackerService.saveMoodLog(
        idUser: idUser,
        indicatorLabel: moodData["label"]!,
        indicatorScore: avgScore,
        indicatorLottie: moodData["lottie"]!,
        answers: _selectedAnswers,
        note: _noteController.text,
      );

      _noteController.clear();
      setState(() {
        _selectedAnswers.clear();
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Saved!")));
      Navigator.pushNamed(context, "/moodTracker");
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.userData;

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
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.reply, color: Color(0xFF73a664)),
                  onPressed: () => Navigator.pushNamed(context, "/moodTracker"),
                  tooltip: "Back",
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading || user == null
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5A7863)),
            )
          : Column(
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
                      const Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Tell Me Your Mood",
                        style: GoogleFonts.modernAntiqua(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final question = _questions[index];
                      return CardQuestion(
                        question: question,
                        selectedAnswers: _selectedAnswers,
                      );
                    },
                  ),
                ),

                Container(
                  decoration: inset.BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                    color: Color(0xFF73a664),
                    boxShadow: [
                      inset.BoxShadow(
                        color: Colors.black45.withOpacity(0.5),
                        blurRadius: 2,
                        offset: Offset(0, 2),
                        inset: true,
                      ),
                    ],
                  ),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: inset.BoxDecoration(
                            color: const Color(0xFF252A34),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              inset.BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 3,
                                offset: Offset(3, 2),
                                inset: true,
                              ),
                              inset.BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                offset: Offset(-3, -2),
                                inset: true,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _noteController,
                            style: GoogleFonts.bricolageGrotesque(
                              color: Colors.white,
                            ),
                            decoration: const InputDecoration(
                              hintText: "Note (opsional)",
                              hintStyle: TextStyle(color: Colors.white60),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _submitData(user.docId!),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: inset.BoxDecoration(
                            shape: BoxShape.circle,
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
                          child: const Icon(
                            Icons.send_rounded,
                            color: Color(0xFF73a664),
                            size: 22,
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
