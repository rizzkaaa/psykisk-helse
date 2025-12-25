import 'package:cloud_firestore/cloud_firestore.dart';

extension UniqueFieldChecker on CollectionReference {
  Future<void> checkUniqueField({
    required String field,
    required String value,
    required String uid,
  }) async {
    final query = await where(field, isEqualTo: value).limit(1).get();

    if (query.docs.isNotEmpty && query.docs.first.id != uid) {
      throw Exception("$field sudah digunakan");
    }
  }
}

extension TimeAgoExtension on DateTime {
  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inMinutes < 1) return "baru saja";
    if (diff.inHours < 1) return "${diff.inMinutes} menit lalu";
    if (diff.inHours < 24) return "${diff.inHours} jam lalu";
    return "${diff.inDays} hari lalu";
  }
}
