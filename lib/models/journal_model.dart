import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/base_model.dart';

class JournalModel extends BaseModel {
  final String _idUser;
  final String _title;
  final String _content;
  final bool _isPublic;

  JournalModel({
    super.docId,
    required String idUser,
    required String title,
    required String content,
    required bool isPublic,
    super.createdAt,
    super.updatedAt,
  }) : _idUser = idUser,
       _title = title,
       _content = content,
       _isPublic = isPublic;

  String get idUser => _idUser;
  String get title => _title;
  String get content => _content;
  bool get isPublic => _isPublic;

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      idUser: json['idUser'] ?? '-',
      title: json['title'] ?? '-',
      content: json['content'] ?? '-',
      isPublic: json['isPublic'] ?? false,
    );
  }

  factory JournalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalModel(
      docId: doc.id,
      idUser: data['idUser'] ?? '-',
      title: data['title'] ?? '-',
      content: data['content'] ?? '-',
      isPublic: data['isPublic'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': _idUser,
      'title': _title,
      'content': _content,
      'isPublic': _isPublic,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'idUser': _idUser,
      'title': _title,
      'content': _content,
      'isPublic': _isPublic,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}