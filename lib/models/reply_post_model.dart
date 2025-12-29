import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/base_post_model.dart';

class ReplyPost extends BasePost {
  final String idUser;
  final String role;
  final String? idReply;
  final String? parentUserID;

  ReplyPost({
    required super.id,
    required super.content,
    required super.timestamp,
    required this.idUser,
    required this.role,
    this.parentUserID,
    this.idReply,
  });

  @override
  String get displayRole {
    return role == 'Counsultant' ? "(Counsultant)" : "";
  }

  factory ReplyPost.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ReplyPost(
      id: doc.id,
      idUser: data['idUser'],
      role: data['role'],
      content: data['content'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      parentUserID: data['parentUserID'],
      idReply: data['idReply'] ?? "",
    );
  }
}