abstract class BasePost {
  final String _id;
  final String _content;
  final DateTime _timestamp;

  BasePost({
    required String id,
    required String content,
    required DateTime timestamp,
  })  : _id = id,
        _content = content,
        _timestamp = timestamp;

  String get id => _id;
  String get content => _content;
  DateTime get timestamp => _timestamp;

  String get displayRole;
}
