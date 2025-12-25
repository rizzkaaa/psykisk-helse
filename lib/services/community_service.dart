import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/post_model.dart';

class CommunityService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- POSTINGAN (Existing - Tidak Diubah) ---
  Stream<List<PostModel>> getPostsStream() {
    return _db.collection('posts').orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => PostModel.fromFirestore(doc)).toList();
    });
  }

  // --- POSTINGAN (DITAMBAHKAN PARAMETER OPSIONAL UNTUK REPLY) ---
  // Kode asli dipertahankan, ditambahkan field replyToContent & replyToUser
  Future<void> addPost(String content, {String? replyToContent, String? replyToUser}) async {
    if (content.trim().isEmpty) return;
    
    await _db.collection('posts').add({
      'username': 'Anonymous User',
      'tag': replyToContent != null ? 'Reply' : 'General', // Dinamis jika reply
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'likes': 0,
      'comments': 0,
      'isAnonymous': true,
      // TAMBAHAN: Untuk fitur Quote Reply agar muncul Card baru dengan referensi pesan
      'replyToContent': replyToContent, 
      'replyToUser': replyToUser,
    });
  }

  Future<void> likePost(String postId, int currentLikes) async {
    await _db.collection('posts').doc(postId).update({'likes': currentLikes + 1});
  }

  // --- KOMENTAR & REPLY (BARU - Sesuai Kode Kamu) ---

  // 1. Ambil list komentar berdasarkan Post ID (Realtime)
  Stream<QuerySnapshot> getCommentsStream(String postId) {
    return _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // 2. Kirim Komentar Baru
  Future<void> addComment(String postId, String content) async {
    if (content.trim().isEmpty) return;

    // Tambah ke sub-collection 'comments'
    await _db.collection('posts').doc(postId).collection('comments').add({
      'username': 'User Kamu', // Harusnya dari Auth
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'isAnonymous': false,
      'replies': [], // Array kosong untuk menampung balasan nanti
    });

    // Update jumlah komentar di postingan utama
    await _db.collection('posts').doc(postId).update({
      'comments': FieldValue.increment(1),
    });
  }

  // 3. Kirim Balasan (Reply) ke Komentar Tertentu
  Future<void> addReply(String postId, String commentId, String content) async {
    if (content.trim().isEmpty) return;

    final replyData = {
      'username': 'User Kamu',
      'content': content,
      'timestamp': Timestamp.now(), // Simpan waktu lokal saja biar mudah
    };

    // Masukkan reply ke dalam array 'replies' di dokumen komentar
    await _db
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .update({
      'replies': FieldValue.arrayUnion([replyData]),
    });
    
    // Update total comments count juga jika mau reply dihitung
    await _db.collection('posts').doc(postId).update({
      'comments': FieldValue.increment(1),
    });
  }
}