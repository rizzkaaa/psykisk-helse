import 'package:uas_project/models/post_model.dart';

class ReplyPost extends PostModel {
  final String replyToContent;

  ReplyPost({
    required super.id,
    required super.content,
    required super.timestamp,
    required super.username,
    required super.tag,
    required super.likes,
    required super.comments,
    required super.isAnonymous,
    required this.replyToContent,
  });

  @override
  String get displayUsername {
    return "↪ ${super.displayUsername}";
  }
}
