
abstract class BaseModel {
  final String? _docId;
  final DateTime? _createdAt;
  final DateTime? _updatedAt;

  BaseModel({String? docId, DateTime? createdAt, DateTime? updatedAt})
    : _docId = docId,
      _createdAt = createdAt,
      _updatedAt = updatedAt;

  // Getter (Encapsulation)
  String? get docId => _docId;
  DateTime? get createdAt => _createdAt;
  DateTime? get updatedAt => _updatedAt;
}
