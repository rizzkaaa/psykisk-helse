import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? docId;
  final String fullname;
  final String username;
  final String email;
  final String photo;
  final String role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    this.docId,
    required this.fullname,
    required this.username,
    required this.email,
    required this.photo,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullname: json['fullname'] ?? '-',
      username: json['username'] ?? '-',
      email: json['email'] ?? '-',
      photo: json['photo'] ?? '-',
      role: json['role'] ?? '-',
      isActive: json['isActive'] ?? '-',
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
      role: data['role'] ?? '-',
      isActive: data['isActive'] ?? '-',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullname': fullname,
      'username': username,
      'email': email,
      'photo': photo,
      'role': role,
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'fullname': fullname,
      'username': username,
      'email': email,
      'photo': photo,
      'role': role,
      'isActive': isActive,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
