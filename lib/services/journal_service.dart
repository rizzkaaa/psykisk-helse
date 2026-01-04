import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/journal_model.dart';

class JournalService {
  final _journalRef = FirebaseFirestore.instance.collection("journal");

  Future<List<JournalModel>> getAllJournalByUser({
    required String idUser,
  }) async {
    final snapshot = await _journalRef.get();

    final results = snapshot.docs
        .map((doc) => JournalModel.fromFirestore(doc))
        .where((journal) => journal.idUser == idUser)
        .toList();

    results.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return results;
  }

  Future<List<JournalModel>> getAllJournalPublic() async {
    final snapshot = await _journalRef.get();

    final results = snapshot.docs
        .map((doc) => JournalModel.fromFirestore(doc))
        .where((journal) => journal.isPublic == true)
        .toList();
    results.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    return results;
  }

  Future<JournalModel> getJournalByID({required String idJournal}) async {
    final doc = await _journalRef.doc(idJournal).get();
    return JournalModel.fromFirestore(doc);
  }

  Future<List<JournalModel>> getBookmarkedJournal(String userId) async {
    final postSnapshot = await _journalRef
        .orderBy('createdAt', descending: true)
        .get();

    final bookmarkSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookmark')
        .where('type', isEqualTo: 'journal')
        .get();

    final bookmarkIds = bookmarkSnapshot.docs
        .map((doc) => doc['id'] as String)
        .toSet();

    return postSnapshot.docs
        .where((doc) => bookmarkIds.contains(doc.id))
        .map((doc) => JournalModel.fromFirestore(doc))
        .toList();
  }

  Future<JournalModel> addJournal({
    required String idUser,
    required String title,
    required String content,
    required bool isPublic,
  }) async {
    try {
      final docRef = await _journalRef.add({
        "idUser": idUser,
        "title": title,
        "content": content,
        "isPublic": isPublic,
        'createdAt': Timestamp.fromDate(DateTime.now()),
      });
      return JournalModel(
        docId: docRef.id,
        idUser: idUser,
        title: title,
        content: content,
        isPublic: isPublic,
      );
    } catch (e) {
      print("Error menambah journal: $e");
      rethrow;
    }
  }

  Future<JournalModel> editJournal({
    required String idJournal,
    required String title,
    required String content,
    required bool isPublic,
  }) async {
    try {
      await _journalRef.doc(idJournal).update({
        "title": title,
        "content": content,
        "isPublic": isPublic,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      final doc = await _journalRef.doc(idJournal).get();
      return JournalModel.fromFirestore(doc);
    } catch (e) {
      print("Error mengedit journal: $e");
      rethrow;
    }
  }

  Future<List<JournalModel>> searchJournal({
    required bool isPublic,
    required String query,
    String? idUser,
  }) async {
    final q = query.toLowerCase();
    List<JournalModel> journals;

    if (isPublic) {
      journals = await getAllJournalPublic();
    } else {
      journals = await getAllJournalByUser(idUser: idUser!);
    }

    return journals
        .where((journal) => journal.title.toLowerCase().contains(q))
        .toList();
  }

  Future<bool> bookmarkJournal(String idUser, String idJournal) async {
    final docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(idUser)
        .collection("bookmark")
        .doc(idJournal);

    final snap = await docRef.get();
    final isBookmarked = snap.exists;

    if (isBookmarked) {
      await docRef.delete();
      return false;
    } else {
      await docRef.set({
        'type': 'journal',
        'id': idJournal,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    }
  }

  Future<bool> isJournalBookmarked(String idUser, String idJournal) async {
    final userBookmark = FirebaseFirestore.instance
        .collection("users")
        .doc(idUser)
        .collection("bookmark")
        .doc(idJournal);

    final snap = await userBookmark.get();
    return snap.exists;
  }

  Future<void> deleteJournal({required String idJournal}) async {
    try {
      await _journalRef.doc(idJournal).delete();
    } catch (e) {
      print("Failed delete journal: $e");
      rethrow;
    }
  }
}
