import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/base_post_model.dart';

class PostModel extends BasePost {
  final String _username;
  final String tag;
  final int likes;
  final int comments;
  final bool isAnonymous;

  PostModel({
    required super.id,
    required super.content,
    required super.timestamp,
    required String username,
    required this.tag,
    required this.likes,
    required this.comments,
    required this.isAnonymous,
  }) : _username = username;

  @override
  String get displayUsername {
    return isAnonymous ? "Anonymous" : _username;
  }

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PostModel(
      id: doc.id,
      username: data['username'] ?? '',
      tag: data['tag'] ?? '',
      content: data['content'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      isAnonymous: data['isAnonymous'] ?? false,
    );
  }
}
