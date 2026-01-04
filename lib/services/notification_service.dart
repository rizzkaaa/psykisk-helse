import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  Stream<int> getCountUnRead() {
    if (userId == null) return Stream.value(0);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<List<Map<String, dynamic>>> getNotif() {
    if (userId == null) {
      print("user tidak ada");
      return Stream.value([]);
    }

    print(userId);
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('time', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<Map<String, dynamic>> notifications = [];

          for (var doc in snapshot.docs) {
            final data = doc.data();
            print(data);
            final notifDoc = await _firestore
                .collection('notification')
                .doc(data['notifID'])
                .get();

            if (notifDoc.exists) {
              notifications.add({
                'id': doc.id,
                'isRead': data['isRead'] ?? false,
                'time': data['time'],
                ...notifDoc.data()!,
              });
            }
            print(notifDoc.exists);
          }

          print(notifications);
          return notifications;
        });
  }

  Future<void> markAllAsRead() async {
    if (userId == null) return;

    final batch = _firestore.batch();

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  Future<void> createNotification({
    required String title,
    required String message,
  }) async {
    final notifRef = _firestore.collection('notification').doc();

    await notifRef.set({'title': title, 'message': message});

    final usersSnapshot = await _firestore.collection('users').get();

    final batch = _firestore.batch();

    for (var userDoc in usersSnapshot.docs) {
      final userNotifRef = _firestore
          .collection('users')
          .doc(userDoc.id)
          .collection('notifications')
          .doc(notifRef.id);

      batch.set(userNotifRef, {
        'notifID': notifRef.id,
        'isRead': false,
        'time': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  Future<void> createPersonalNotif(String userID, String type) async {
    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection('notifications')
          .add({
            'notifID': type,
            'isRead': false,
            'time': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteNotification(String notifID) async {
    if (userId == null) return;

    print(notifID);
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notifID)
        .delete();
  }

  Future<void> deleteAllNotification() async {
    if (userId == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
