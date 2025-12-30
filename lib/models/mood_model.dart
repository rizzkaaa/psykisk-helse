import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/base_model.dart';

class MoodModel extends BaseModel {
  final String _idUser;
  final String _indicatorLabel;
  final int _indicatorScore;
  final String _indicatorLottie;
  final Map<String, String> _answer;
  final String? _note;

  MoodModel({
    super.docId,
    required String idUser,
    required String indicatorLabel,
    required int indicatorScore,
    required String indicatorLottie,
    required Map<String, String> answer,
    String? note,
    super.createdAt,
  }) : _idUser = idUser,
       _indicatorLabel = indicatorLabel,
       _indicatorScore = indicatorScore,
       _indicatorLottie = indicatorLottie,
       _answer = answer,
       _note = note;

  String get indicatorLabel => _indicatorLabel;
  int get indicatorScore => _indicatorScore;
  String get indicatorLottie => _indicatorLottie;
  Map<String, String> get answer => _answer;
  String? get note => _note;

  factory MoodModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MoodModel(
      docId: doc.id,
      idUser: data['idUser'] ?? '',
      indicatorLabel: data['indicator_label'] ?? '',
      indicatorScore: (data['indicator_score'] ?? 0).toInt(),
      indicatorLottie: data['indicator_lottie'] ?? '',
      answer: Map<String, String>.from(data['answers'] ?? {}),
      note: data['note'],
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
    );
  }

  // ===== TO MAP (Object → Firestore) =====
  Map<String, dynamic> toMap() {
    return {
      'idUser': _idUser,
      'indicator_label': _indicatorLabel,
      'indicator_score': _indicatorScore,
      'indicator_lottie': _indicatorLottie,
      'answers': _answer,
      'note': _note,
      'created_at': createdAt,
    };
  }
}

class MoodOption {
  final String teks;
  final int skor;

  MoodOption({required this.teks, required this.skor});

  factory MoodOption.fromJson(Map<String, dynamic> json) {
    return MoodOption(teks: json['teks'] as String, skor: json['skor'] as int);
  }
}

class MoodQuestion {
  final String id;
  final String pertanyaan;
  final List<MoodOption> opsi;

  MoodQuestion({
    required this.id,
    required this.pertanyaan,
    required this.opsi,
  });

  factory MoodQuestion.fromJson(Map<String, dynamic> json) {
    var list = json['opsi'] as List;
    List<MoodOption> opsiList = list
        .map((i) => MoodOption.fromJson(i))
        .toList();

    return MoodQuestion(
      id: json['id'],
      pertanyaan: json['pertanyaan'],
      opsi: opsiList,
    );
  }
}
