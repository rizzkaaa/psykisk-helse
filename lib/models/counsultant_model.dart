import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class CounsultantModel extends BaseModel {
  final String _idUser;
  final String _spesialis;
  final String _availableTime;
  final String _status;
  final String _whatsappNo;

  CounsultantModel({
    super.docId,
    required String idUser,
    required String spesialis,
    required String availableTime,
    required String status,
    required String whatsappNo,
    super.createdAt,
    super.updatedAt,
  }) : _idUser = idUser,
       _spesialis = spesialis,
       _availableTime = availableTime,
       _status = status,
       _whatsappNo = whatsappNo;

  String get idUser => _idUser;
  String get spesialis => _spesialis;
  String get availableTime => _availableTime;
  String get status => _status;
  String get whatsappNo => _whatsappNo;

  factory CounsultantModel.fromJson(Map<String, dynamic> json) {
    return CounsultantModel(
      idUser: json['idUser'] ?? '-',
      spesialis: json['spesialis'] ?? '-',
      availableTime: json['availableTime'] ?? '-',
      status: json['status'] ?? 'user',
      whatsappNo: json['whatsappNo'] ?? '',
    );
  }

  factory CounsultantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CounsultantModel(
      docId: doc.id,
      idUser: data['id_user'] ?? '-',
      spesialis: data['spesialis'] ?? '-',
      availableTime: data['available_time'] ?? '-',
      status: data['status'] ?? 'user',
      whatsappNo: data['whatsappNo'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idUser': _idUser,
      'spesialis': _spesialis,
      'availableTime': _availableTime,
      'status': _status,
      'whatsappNo': _whatsappNo,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'idUser': _idUser,
      'spesialis': _spesialis,
      'availableTime': _availableTime,
      'status': _status,
      'whatsappNo': _whatsappNo,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class CounsultantDocumentModel {
  final String fileBase64;

  CounsultantDocumentModel({required this.fileBase64});

  factory CounsultantDocumentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CounsultantDocumentModel(
      fileBase64: data['file_base64'],
    );
  }
}

