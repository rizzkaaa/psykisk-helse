import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/base_post_model.dart';

class PostModel extends BasePost {
  final String _idUser;
  final String _role;
  final String _tag;
  final int _likes;
  final int _comments;

  PostModel({
    required super.id,
    required super.content,
    required super.timestamp,
    required String idUser,
    required String role,
    required String tag,
    required int likes,
    required int comments,
  }) : _idUser = idUser,
       _role = role,
       _tag = tag,
       _likes = likes,
       _comments = comments;

  @override
  String get displayRole {
    return _role == 'Counsultant' ? "(Counsultant)" : "";
  }

  String get idUser => _idUser;
  String get role => _role;
  String get tag => _tag;
  int get likes => _likes;
  int get comments => _comments;

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PostModel(
      id: doc.id,
      idUser: data['idUser'] ?? '',
      role: data['role'] ?? '',
      tag: data['tag'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
    );
  }
}
