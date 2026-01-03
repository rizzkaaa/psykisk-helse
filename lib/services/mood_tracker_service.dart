import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/mood_model.dart';

class MoodTrackerService extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  MoodModel? moodDataToday;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, String>> moodData = [
    {
      "label": "Terrible",
      "lottie": "terrible-emoji.json",
      "text":
          "It's okay to feel like this. You've survived 100% of your worst days so far.",
    },
    {
      "label": "Kinda Bad",
      "lottie": "bad-emoji.json",
      "text":
          "Not every day is good, and that's okay. Take it one step at a time.",
    },
    {
      "label": "Okay",
      "lottie": "happy-emoji.json",
      "text": "You're doing fine. Even small progress is still progress.",
    },
    {
      "label": "Pretty Good",
      "lottie": "good-emoji.json",
      "text": "Hold onto this feeling. You're doing something right.",
    },
    {
      "label": "Amazing",
      "lottie": "amazing-emoji.json",
      "text": "You're glowing today. Keep being proud of how far you've come.",
    },
  ];
  
  Future<void> loadMood({bool force = false, required String idUser}) async {
    if (isLoading) return;
    if (moodDataToday != null && !force) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

      final snapshot = await _firestore
          .collection('mood_logs')
          .where('idUser', isEqualTo: idUser)
          .where(
            'created_at',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where(
            'created_at',
            isLessThanOrEqualTo: Timestamp.fromDate(endOfDay),
          )
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        moodDataToday = MoodModel.fromFirestore(snapshot.docs.first);
      } else {
        moodDataToday = null;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  
  Future<List<MoodQuestion>> loadQuestions() async {
    final String response = await rootBundle.loadString(
      'assets/data/questions.json',
    );
    final List<dynamic> data = jsonDecode(response);

    return data.map((e) => MoodQuestion.fromJson(e)).toList();
  }

  Future<List<MoodModel>> fetchMoodByUser(String idUser) async {
    final snapshot = await _firestore
        .collection("mood_logs")
        .where("idUser", isEqualTo: idUser)
        .get();

    return snapshot.docs.map((doc) => MoodModel.fromFirestore(doc)).toList();
  }

  double calculateAvgScore(
    Map<String, MoodOption> selectedAnswers,
    int totalQuestions,
  ) {
    if (selectedAnswers.isEmpty) return 0.0;

    int total = 0;
    selectedAnswers.forEach((_, v) => total += v.skor);

    return total / totalQuestions;
  }

  Future<bool> hasMoodLogToday(String idUser) async {
    final now = DateTime.now();

    final startOfDay = DateTime(now.year, now.month, now.day);

    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    final query = await _firestore
        .collection('mood_logs')
        .where('idUser', isEqualTo: idUser)
        .where(
          'created_at',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('created_at', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .limit(1)
        .get();

    print(query.docs.isNotEmpty);
    return query.docs.isNotEmpty;
  }

  Future<void> saveMoodLog({
    required String idUser,
    required String indicatorLabel,
    required double indicatorScore,
    required String indicatorLottie,
    required Map<String, MoodOption> answers,
    String? note,
  }) async {
    final alreadyLogged = await hasMoodLogToday(idUser);

    if (alreadyLogged) return;

    try {
      await _firestore.collection('mood_logs').add({
        'idUser': idUser,
        'indicator_label': indicatorLabel,
        'indicator_score': indicatorScore.toInt(),
        'indicator_lottie': indicatorLottie,
        'answers': answers.map((k, v) => MapEntry(k, v.teks)),
        'note': note ?? "",
        'created_at':  Timestamp.fromDate(DateTime.now()),
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
