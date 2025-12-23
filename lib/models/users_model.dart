import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class UserModel extends BaseModel {
  final String _fullname;
  final String _username;
  final String _email;
  final String _photo;
  final String _role;
  final bool _isActive;

  UserModel({
    String? docId,
    required String fullname,
    required String username,
    required String email,
    required String photo,
    required String role,
    required bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : _fullname = fullname,
        _username = username,
        _email = email,
        _photo = photo,
        _role = role,
        _isActive = isActive,
        super(
          docId: docId,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  String get fullname => _fullname;
  String get username => _username;
  String get email => _email;
  String get photo => _photo;
  String get role => _role;
  bool get isActive => _isActive;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullname: json['fullname'] ?? '-',
      username: json['username'] ?? '-',
      email: json['email'] ?? '-',
      photo: json['photo'] ?? '-',
      role: json['role'] ?? 'user',
      isActive: json['isActive'] ?? false,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      docId: doc.id,
      fullname: data['fullname'] ?? '-',
      username: data['username'] ?? '-',
      email: data['email'] ?? '-',
      photo: data['photo'] ?? '-',
      role: data['role'] ?? 'user',
      isActive: data['isActive'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': _fullname,
      'username': _username,
      'email': _email,
      'photo': _photo,
      'role': _role,
      'isActive': _isActive,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullname': _fullname,
      'username': _username,
      'email': _email,
      'photo': _photo,
      'role': _role,
      'isActive': _isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  bool get isAdmin => _role == 'admin';
}
