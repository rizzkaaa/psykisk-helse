import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:uas_project/models/mood_model.dart';
import 'package:lottie/lottie.dart';

class MoodTrackerScreen1 extends StatefulWidget {
  const MoodTrackerScreen1({super.key});

  @override
  State<MoodTrackerScreen1> createState() => _MoodTrackerScreen1State();
}

class _MoodTrackerScreen1State extends State<MoodTrackerScreen1> {
  final List<Map<String, String>> _moodData = [
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

  double _manualValue = 2.0;
  List<MoodQuestion> _questions = [];
  final Map<String, MoodOption> _selectedAnswers = {};
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final String response = await rootBundle.loadString(
      'assets/data/questions.json',
    );
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      _questions = data.map((e) => MoodQuestion.fromJson(e)).toList();
      _isLoading = false;
    });
  }

  String _getLottieByLabel(String label) {
    final mood = _moodData.firstWhere(
      (m) => m['label'] == label,
      orElse: () => _moodData[2],
    );
    return mood['lottie']!;
  }

  double _calculateAvgScore() {
    if (_selectedAnswers.isEmpty) return 0.0;
    int total = 0;
    _selectedAnswers.forEach((k, v) => total += v.skor);
    return total / _questions.length;
  }

  Future<void> _submitData() async {
    if (_selectedAnswers.length < _questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua indikator!")),
      );
      return;
    }

    double avgScore = _calculateAvgScore();

    print(_selectedAnswers.map((k, v) => MapEntry(k, v.teks)));
    // try {
    //   await FirebaseFirestore.instance.collection('mood_logs').add({
    //     'manual_score': _manualValue,
    //     'manual_label': _moodData[_manualValue.toInt()]['label'],
    //     'indicator_label': _moodData[avgScore.round()]['label'],

    //     'indicator_score': avgScore,
    //     'answers': _selectedAnswers.map((k, v) => MapEntry(k, v.teks)),
    //     'note': _noteController.text,
    //     'created_at': FieldValue.serverTimestamp(),
    //   });

    //   _noteController.clear();
    //   setState(() {
    //     _selectedAnswers.clear();
    //     _manualValue = 2.0;
    //   });
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(const SnackBar(content: Text("Berhasil Disimpan!")));
    // } catch (e) {
    //   ScaffoldMessenger.of(
    //     context,
    //   ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FB),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildSliderCard(),
                        const SizedBox(height: 10),
                        const Text(
                          "INDIKATOR HARIAN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        ..._questions
                            .map((q) => _buildQuestionCard(q))
                            .toList(),
                        _buildNoteField(),
                        const SizedBox(height: 30),
                        _buildSaveButton(),
                        const SizedBox(height: 40),
                        _buildHistorySection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mood_logs')
          .orderBy('created_at', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        String label = "Belum Ada Data";
        String emoji = "😶";
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          var data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          label = data['indicator_label'] ?? "Biasa";
          // emoji = _getEmoji(label);
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A1B9A), Color(0xFFAD1457)],
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),
          child: Column(
            children: [
              const Text(
                "MOOD TERAKHIR KAMU",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Lottie.asset(
                "assets/animation/${_getLottieByLabel(label)}",
                height: 120,
              ),

              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliderCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Perasaanmu secara manual?",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Lottie.asset(
              "assets/animation/${_moodData[_manualValue.toInt()]['lottie']}",
              height: 140,
            ),
            const SizedBox(height: 10),
            Text(
              _moodData[_manualValue.toInt()]['text']!,
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
              activeColor: Colors.pink,
              onChanged: (v) => setState(() => _manualValue = v),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(MoodQuestion q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(q.pertanyaan, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...q.opsi.map((opsi) {
          bool selected = _selectedAnswers[q.id]?.teks == opsi.teks;
          return GestureDetector(
            onTap: () => setState(() => _selectedAnswers[q.id] = opsi),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: selected ? Colors.purple.withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: selected ? Colors.purple : Colors.black12,
                  width: 1.5,
                ),
              ),
              child: Text(
                opsi.teks,
                style: TextStyle(
                  color: selected ? Colors.purple : Colors.black87,
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildNoteField() {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: _noteController,
        decoration: const InputDecoration(
          hintText: "Catatan...",
          border: InputBorder.none,
        ),
        maxLines: 2,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _submitData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          "SIMPAN",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mood_logs')
          .orderBy('created_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        var docs = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            String label = data['indicator_label'] ?? "Biasa";
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Lottie.asset(
                  "assets/animation/${_getLottieByLabel(label)}",
                  height: 120,
                ),

                title: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(data['note'] ?? "Tanpa catatan"),
                trailing: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 18,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
