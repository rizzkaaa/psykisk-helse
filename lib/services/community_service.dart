import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/post_model.dart';
import 'package:uas_project/models/reply_post_model.dart';

class CommunityService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<PostModel>> getPostsStream() {
    return _db
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => PostModel.fromFirestore(doc))
              .toList();
        });
  }

  Future<void> addPost(
    String idUser,
    String role,
    String content,
    String tag,
  ) async {
    if (content.trim().isEmpty) return;

    await _db.collection('posts').add({
      'idUser': idUser,
      'role': role,
      'tag': tag,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': 0,
      'comments': 0,
    });
  }

  Future<void> likePost(String userId, String postId, bool increment) async {
    final userLikeRef = _db
        .collection("users")
        .doc(userId)
        .collection("liked")
        .doc(postId);

    final postRef = _db.collection("posts").doc(postId);

    if (increment) {
      await userLikeRef.set({
        'type': 'post',
        'id': postId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await postRef.update({'likes': FieldValue.increment(1)});
    } else {
      await userLikeRef.delete();

      await postRef.update({'likes': FieldValue.increment(-1)});
    }
  }

  Future<bool> isPostLiked(String userId, String postId) async {
    final likeRef = _db
        .collection('users')
        .doc(userId)
        .collection('liked')
        .doc(postId);

    final snap = await likeRef.get();
    return snap.exists;
  }

  Stream<List<Map<String, dynamic>>> getRepliesStream(String postId) {
  return _db
      .collection('posts')
      .doc(postId)
      .collection('reply')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) {
    List<ReplyPost> allReplies = snapshot.docs
        .map((doc) => ReplyPost.fromFirestore(doc))
        .toList();

    return _organizeRepliesTwoLevel(allReplies);
  });
}

List<Map<String, dynamic>> _organizeRepliesTwoLevel(List<ReplyPost> allReplies) {
  // Map untuk akses cepat
  Map<String, ReplyPost> repliesMap = {};
  
  for (var reply in allReplies) {
    repliesMap[reply.id] = reply;
  }
  
  // Pisahkan level 1 (comment ke post) dan level 2 (reply ke comment/reply)
  List<ReplyPost> level1Comments = [];
  Map<String, List<ReplyPost>> level2ByRootParent = {};
  
  // Identifikasi level 1 (comment langsung ke post)
  for (var reply in allReplies) {
    if (reply.idReply == null || reply.idReply!.isEmpty) {
      // Level 1: Comment langsung ke post
      level1Comments.add(reply);
      level2ByRootParent[reply.id] = []; // Initialize list untuk replies-nya
    }
  }
  
  // Proses semua reply yang punya parent (level 2)
  for (var reply in allReplies) {
    if (reply.idReply != null && reply.idReply!.isNotEmpty) {
      // Cari root parent (level 1 comment)
      String rootParentId = _findRootParent(reply.idReply!, repliesMap);
      
      // Tambahkan ke level 2 dari root parent
      if (level2ByRootParent.containsKey(rootParentId)) {
        level2ByRootParent[rootParentId]!.add(reply);
      } else {
        // Jika root parent tidak ditemukan, skip atau handle error
        print("Warning: Root parent not found for reply ${reply.id}");
      }
    }
  }
  for (var replies in level2ByRootParent.values) {
    replies.sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
  // Build result: [{comment: ReplyPost, replies: [ReplyPost]}]
  List<Map<String, dynamic>> result = [];
  for (var comment in level1Comments) {
    result.add({
      'comment': comment,
      'replies': level2ByRootParent[comment.id] ?? [],
    });
  }
  
  return result;
}

// Helper method untuk mencari root parent (level 1 comment)
String _findRootParent(String replyId, Map<String, ReplyPost> repliesMap) {
  ReplyPost? current = repliesMap[replyId];
  
  // Telusuri ke atas sampai ketemu yang tidak punya parent (level 1)
  while (current != null && current.idReply != null && current.idReply!.isNotEmpty) {
    current = repliesMap[current.idReply];
  }
  
  // Return ID dari level 1 comment
  return current?.id ?? replyId;
}

  Future<void> addReply({
    required String postId,
    required String content,
    required String idUser,
    required String role,
    String? parentUserID,
    String? idReply,
  }) async {
    if (content.trim().isEmpty) return;

    await _db.collection('posts').doc(postId).collection('reply').add({
      'idUser': idUser,
      'role': role,
      'parentUserID': parentUserID ?? "",
      'idReply': idReply ?? "",
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _db.collection('posts').doc(postId).update({
      'comments': FieldValue.increment(1),
    });
  }

  // 3. Kirim Balasan (Reply) ke Komentar Tertentu
  // Future<void> addReply(String postId, String commentId, String content) async {
  //   if (content.trim().isEmpty) return;

  //   final replyData = {
  //     'username': 'User Kamu',
  //     'content': content,
  //     'timestamp': Timestamp.now(), // Simpan waktu lokal saja biar mudah
  //   };

  //   // Masukkan reply ke dalam array 'replies' di dokumen komentar
  //   await _db
  //       .collection('posts')
  //       .doc(postId)
  //       .collection('comments')
  //       .doc(commentId)
  //       .update({
  //         'replies': FieldValue.arrayUnion([replyData]),
  //       });

  //   // Update total comments count juga jika mau reply dihitung
  //   await _db.collection('posts').doc(postId).update({
  //     'comments': FieldValue.increment(1),
  //   });
  // }
}
