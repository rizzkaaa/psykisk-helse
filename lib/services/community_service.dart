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

  Stream<List<PostModel>> getLikedPosts(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('liked')
        .where('type', isEqualTo: 'post')
        .snapshots()
        .asyncMap((likedSnapshot) async {
          final likedPostIds = likedSnapshot.docs.map((doc) => doc.id).toSet();

          if (likedPostIds.isEmpty) return [];

          final postSnapshot = await _db
              .collection('posts')
              .orderBy('timestamp', descending: true)
              .get();

          return postSnapshot.docs
              .where((doc) => likedPostIds.contains(doc.id))
              .map((doc) => PostModel.fromFirestore(doc))
              .toList();
        });
  }

  Stream<List<PostModel>> getPostsStreamByIDuser(String idUser) {
    return _db
        .collection('posts')
        .where("idUser", isEqualTo: idUser)
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

  List<Map<String, dynamic>> _organizeRepliesTwoLevel(
    List<ReplyPost> allReplies,
  ) {
    Map<String, ReplyPost> repliesMap = {};

    for (var reply in allReplies) {
      repliesMap[reply.id] = reply;
    }

    List<ReplyPost> level1Comments = [];
    Map<String, List<ReplyPost>> level2ByRootParent = {};

    for (var reply in allReplies) {
      if (reply.idReply == null || reply.idReply!.isEmpty) {
        level1Comments.add(reply);
        level2ByRootParent[reply.id] = [];
      }
    }

    for (var reply in allReplies) {
      if (reply.idReply != null && reply.idReply!.isNotEmpty) {
        String rootParentId = _findRootParent(reply.idReply!, repliesMap);

        if (level2ByRootParent.containsKey(rootParentId)) {
          level2ByRootParent[rootParentId]!.add(reply);
        } else {
          print("Warning: Root parent not found for reply ${reply.id}");
        }
      }
    }
    for (var replies in level2ByRootParent.values) {
      replies.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    List<Map<String, dynamic>> result = [];
    for (var comment in level1Comments) {
      result.add({
        'comment': comment,
        'replies': level2ByRootParent[comment.id] ?? [],
      });
    }

    return result;
  }

  String _findRootParent(String replyId, Map<String, ReplyPost> repliesMap) {
    ReplyPost? current = repliesMap[replyId];

    while (current != null &&
        current.idReply != null &&
        current.idReply!.isNotEmpty) {
      current = repliesMap[current.idReply];
    }

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
}
