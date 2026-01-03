import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class UserModel extends BaseModel {
  final String _fullname;
  final String _username;
  final String _email;
  final String _bio;
  final String _photo;
  final String _headerBanner;
  final String _role;
  final bool _isActive;

  UserModel({
    super.docId,
    required String fullname,
    required String username,
    required String email,
    required String bio,
    required String photo,
    required String headerBanner,
    required String role,
    required bool isActive,
    super.createdAt,
    super.updatedAt,
  }) : _fullname = fullname,
       _username = username,
       _email = email,
       _bio = bio,
       _photo = photo,
       _headerBanner = headerBanner,
       _role = role,
       _isActive = isActive;

  String get fullname => _fullname;
  String get username => _username;
  String get email => _email;
  String get bio => _bio;
  String get photo => _photo;
  String get headerBanner => _headerBanner;
  String get role => _role;
  bool get isActive => _isActive;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullname: json['fullname'] ?? '-',
      username: json['username'] ?? '-',
      email: json['email'] ?? '-',
      bio: json['bio'] ?? '-',
      photo: json['photo'] ?? '-',
      headerBanner: json['headerBanner'] ?? '-',
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
      bio: data['bio'] ?? '-',
      photo: data['photo'] ?? '-',
      headerBanner: data['headerBanner'] ?? '-',
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
      'bio': _bio,
      'photo': _photo,
      'headerBanner': _headerBanner,
      'role': _role,
      'isActive': _isActive,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullname': _fullname,
      'username': _username,
      'email': _email,
      'bio': _bio,
      'photo': _photo,
      'headerBanner': _headerBanner,
      'role': _role,
      'isActive': _isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  String get displayRole {
    return _role == 'counsultant'
        ? "Counsultant"
        : _role == "admin"
        ? "Admin"
        : '';
  }
}
