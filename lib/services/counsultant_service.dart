import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/counsultant_model.dart';
import 'package:uas_project/services/auth_service.dart';
import 'package:path_provider/path_provider.dart';

class CounsultantService {
  final _counsultantRef = FirebaseFirestore.instance.collection(
    'counsultant_requests',
  );
  final _userRef = FirebaseFirestore.instance.collection('users');
  final AuthService auth = AuthService();

  Future<List<CounsultantModel>> getAllRequest() async {
    final snapshot = await _counsultantRef.get();
    return snapshot.docs
        .map((doc) => CounsultantModel.fromFirestore(doc))
        .toList();
  }

  Future<CounsultantModel> getConsultantByIDUser({
    required String idUser,
  }) async {
    final query = await _counsultantRef
        .where("id_user", isEqualTo: idUser)
        .limit(1)
        .get();
print('📦 docs length: ${query.docs.length}');

    if (query.docs.isEmpty) {
      print('❌ DATA TIDAK DITEMUKAN');
      // return null;
    }

    print('✅ DATA DITEMUKAN: ${query.docs.first.id}');
    print('📄 RAW DATA: ${query.docs.first.data()}');
    return CounsultantModel.fromFirestore(query.docs.first);
  }

  Future<CounsultantDocumentModel> getDocument({
    required String requestId,
    required String type,
  }) async {
    print("ini reqID: $type");
    final doc = await _counsultantRef
        .doc(requestId)
        .collection('documents')
        .doc(type)
        .get();

    if (!doc.exists) {
      throw 'Document $type not found';
    }

    return CounsultantDocumentModel.fromFirestore(doc);
  }

  Future<void> aadRequest({
    required String idUser,
    required String spesialis,
    required String availableTime,
    required String ppd,
    required String sipp,
    required String strp,
    required String whatsappNo,
  }) async {
    try {
      final docRef = await _counsultantRef.add({
        'id_user': idUser,
        'spesialis': spesialis,
        'available_time': availableTime,
        'whatsappNo': whatsappNo,
        'status': 'waiting',
        'create_at': Timestamp.fromDate(DateTime.now()),
      });

      await Future.wait([
        addDoc(docRef, 'ppd', ppd),
        addDoc(docRef, 'sipp', sipp),
        addDoc(docRef, 'strp', strp),
      ]);
    } catch (e) {
      print(e);
    }
  }

  Future<void> addDoc(
    DocumentReference parent,
    String type,
    String base64,
  ) async {
    await parent.collection('documents').doc(type).set({
      'type': type,
      'file_base64': base64,
      'created_at': Timestamp.now(),
    });
  }

  Future<void> validateFileSize(File file, int maxKb) async {
    final bytes = await file.length();
    if (bytes > maxKb * 1024) {
      throw Exception('File terlalu besar (maks $maxKb KB)');
    }
  }

  Future<String> toBase64(File file, int maxKb) async {
    await validateFileSize(file, maxKb);
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  Future<String> pdfToBase64(File pdf) async {
    return toBase64(pdf, 300);
  }

  Future<void> changeStatus({
    required String idRequest,
    required String idUser,
    required String status,
  }) async {
    try {
      final userCheck = await _userRef.doc(idUser).get();

      if (!userCheck.exists) {
        print("User Not Found");
        return;
      }

      await _counsultantRef.doc(idRequest).update({'status': status});
      await auth.setCounsultant(status == 'approved', idUser);

      // notifService.createPersonalNotif(idUser, add ? 'addAdmin' : 'unAdmin');

      return;
    } catch (e) {
      print(e);
    }
  }

  Future<File> saveBase64Pdf({
    required String base64,
    required String fileName,
  }) async {
    print(base64);
    final bytes = base64Decode(base64);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.pdf');

    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}
