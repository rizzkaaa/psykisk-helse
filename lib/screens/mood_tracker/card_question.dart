import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uas_project/models/mood_model.dart';
import 'package:uas_project/services/mood_tracker_service.dart';

class CardQuestion extends StatefulWidget {
  final MoodQuestion question;
  final Map<String, MoodOption> selectedAnswers;
  const CardQuestion({super.key, required this.question, required this.selectedAnswers});

  @override
  State<CardQuestion> createState() => _CardQuestionState();
}

class _CardQuestionState extends State<CardQuestion> {
  final MoodTrackerService _moodTrackerService = MoodTrackerService();
  double _manualValue = 2.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.question.pertanyaan,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Lottie.asset(
              "assets/animation/${_moodTrackerService.moodData[_manualValue.toInt()]['lottie']}",
              height: 100,
            ),
            const SizedBox(height: 10),
            Text(
              widget.question.opsi[_manualValue.toInt()].teks,
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
                 widget.selectedAnswers[widget.question.id] = widget.question.opsi[_manualValue.toInt()];
               }); 
              },
            ),
          ],
        ),
      ),
    );
  }
}
