import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_project/models/post_model.dart';
import 'package:uas_project/services/community_service.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF73a664),
        leading: SizedBox(),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        actions: [
          Container(
            decoration: inset.BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(2, 0),
                  inset: true,
                ),
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(-2, 0),
                  inset: true,
                ),
              ],
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.reply, color: Color(0xFF73a664)),
                  onPressed: () => Navigator.pop(context),
                  tooltip: "Back",
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Color(0xFF73a664),
                  ),
                  onPressed: () {},
                  tooltip: "Clear",
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF73a664)),
                  onPressed: () {},
                  tooltip: "Refresh",
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            decoration: inset.BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              color: Color(0xFF73a664),
              boxShadow: [
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(2, 0),
                  inset: false,
                ),
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(-2, 0),
                  inset: false,
                ),
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(0, -2),
                  inset: true,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.notifications, color: Colors.white, size: 40),
                const SizedBox(width: 8),
                Text(
                  "Notifications",
                  style: GoogleFonts.modernAntiqua(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// class CommunityScreen extends StatelessWidget {
//   final CommunityService _service = CommunityService();

//   CommunityScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // SystemChrome.setSystemUIOverlayStyle(
//     //   const SystemUiOverlayStyle(
//     //     statusBarColor: Colors.transparent,
//     //     statusBarIconBrightness: Brightness.light,
//     //   ),
//     // );

//     return Scaffold(
//       backgroundColor: const Color(0xFFF3E5F5), // Background Ungu Muda
//       body: Column(
//         children: [
//           const _HeaderSection(),
//           Expanded(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               children: [
//                 const SizedBox(height: 24),
//                 _InputCard(service: _service),
//                 const SizedBox(height: 24),
//                 _FeedList(service: _service),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // --- HEADER & INPUT (TIDAK BERUBAH) ---
// class _HeaderSection extends StatelessWidget {
//   const _HeaderSection();
//   @override
//   Widget build(BuildContext context) {
//     final double topPadding = MediaQuery.of(context).padding.top;
//     return Container(
//       padding: EdgeInsets.fromLTRB(24, topPadding + 20, 24, 30),
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFFAC32E4), Color(0xFF7918F2), Color(0xFF4801FF)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(30),
//           bottomRight: Radius.circular(30),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x407918F2),
//             blurRadius: 20,
//             offset: Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Transform.translate(
//             offset: const Offset(-8, 0),
//             child: InkWell(
//               onTap: () => Navigator.pop(context),
//               borderRadius: BorderRadius.circular(50),
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 child: const Icon(
//                   Icons.arrow_back,
//                   color: Colors.white,
//                   size: 26,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             "Komunitas",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "Berbagi dan saling mendukung",
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.9),
//               fontSize: 15,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _InputCard extends StatefulWidget {
//   final CommunityService service;
//   const _InputCard({required this.service});
//   @override
//   State<_InputCard> createState() => _InputCardState();
// }

// class _InputCardState extends State<_InputCard> {
//   final TextEditingController _controller = TextEditingController();
//   bool _isPosting = false;
//   void _handlePost() async {
//     if (_controller.text.trim().isEmpty) return;
//     setState(() => _isPosting = true);
//     await widget.service.addPost(_controller.text);
//     if (mounted) {
//       _controller.clear();
//       setState(() => _isPosting = false);
//       FocusScope.of(context).unfocus();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 24),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF4A00E0).withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: const BoxDecoration(
//               color: Color(0xFFFFF3E0),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.face, color: Colors.orange, size: 24),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               decoration: const InputDecoration(
//                 hintText: "Bagikan ceritamu...",
//                 hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: _isPosting ? null : _handlePost,
//             icon: _isPosting
//                 ? const SizedBox(
//                     width: 20,
//                     height: 20,
//                     child: CircularProgressIndicator(strokeWidth: 2),
//                   )
//                 : const Icon(Icons.add, color: Color(0xFFAC32E4)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _FeedList extends StatelessWidget {
//   final CommunityService service;
//   const _FeedList({required this.service});
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<PostModel>>(
//       stream: service.getPostsStream(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting)
//           return const Center(child: CircularProgressIndicator());
//         final posts = snapshot.data ?? [];
//         return ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           itemCount: posts.length,
//           separatorBuilder: (c, i) => const SizedBox(height: 16),
//           itemBuilder: (context, index) {
//             return _PostCard(post: posts[index], service: service);
//           },
//         );
//       },
//     );
//   }
// }

// // --- POST CARD (DIUBAH MENJADI STATEFUL UNTUK INLINE REPLY) ---
// class _PostCard extends StatefulWidget {
//   final PostModel post;
//   final CommunityService service;

//   const _PostCard({required this.post, required this.service});

//   @override
//   State<_PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<_PostCard> {
//   bool _showInlineReply = false;
//   final TextEditingController _replyController = TextEditingController();

//   void _showCommentSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) =>
//           _CommentModal(postId: widget.post.id, service: widget.service),
//     );
//   }

//   // --- LOGIKA BARU: MENGIRIM REPLY SEBAGAI CARD BARU (QUOTE POST) ---
//   void _sendInlineQuoteReply() async {
//     if (_replyController.text.trim().isEmpty) return;

//     // Memanggil addPost dengan parameter reply untuk membuat Card Baru di Feed
//     await widget.service.addPost(
//       _replyController.text,
//       replyToContent: widget.post.content,
//       replyToUser: widget.post.username,
//     );

//     _replyController.clear();
//     setState(() => _showInlineReply = false);

//     if (mounted) {
//       FocusScope.of(context).unfocus();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Berhasil membalas di komunitas")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.03),
//             blurRadius: 15,
//             offset: const Offset(0, 5),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // --- TAMBAHAN: TAMPILAN PESAN YANG DI-REPLY (QUOTE) ---
//           if (widget.post.replyToContent != null)
//             Container(
//               margin: const EdgeInsets.only(bottom: 12),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF5F5F5),
//                 borderRadius: BorderRadius.circular(12),
//                 border: const Border(
//                   left: BorderSide(color: Color(0xFF7918F2), width: 4),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Membalas @${widget.post.replyToUser}",
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 11,
//                       color: Color(0xFF7918F2),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     widget.post.replyToContent!,
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                       fontSize: 13,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 20,
//                 backgroundColor: widget.post.isAnonymous
//                     ? const Color(0xFFFFF3E0)
//                     : const Color(0xFFF3E5F5),
//                 child: Icon(
//                   widget.post.isAnonymous ? Icons.face : Icons.person,
//                   color: widget.post.isAnonymous
//                       ? Colors.orange
//                       : Colors.purple,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.post.username,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       children: [
//                         Text(
//                           widget.post.timeAgo,
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 11,
//                           ),
//                         ),
//                         const SizedBox(width: 6),
//                         const Text(
//                           "•",
//                           style: TextStyle(color: Colors.grey, fontSize: 10),
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           widget.post.tag.isNotEmpty
//                               ? widget.post.tag
//                               : "General",
//                           style: const TextStyle(
//                             color: Color(0xFF7918F2),
//                             fontSize: 11,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             widget.post.content,
//             style: const TextStyle(
//               height: 1.5,
//               color: Color(0xFF333333),
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 16),
//           const Divider(height: 1, color: Color(0xFFF0F0F0)),
//           const SizedBox(height: 12),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               InkWell(
//                 onTap: () =>
//                     widget.service.likePost(widget.post.id, widget.post.likes),
//                 borderRadius: BorderRadius.circular(8),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 4,
//                     horizontal: 4,
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         widget.post.likes > 0
//                             ? Icons.favorite
//                             : Icons.favorite_border_rounded,
//                         size: 20,
//                         color: widget.post.likes > 0
//                             ? Colors.red
//                             : Colors.grey[500],
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         "${widget.post.likes}",
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 24),

//               InkWell(
//                 onTap: () => _showCommentSheet(context),
//                 borderRadius: BorderRadius.circular(8),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 4,
//                     horizontal: 4,
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.chat_bubble_outline_rounded,
//                         size: 20,
//                         color: Colors.grey[500],
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         "${widget.post.comments}",
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const Spacer(),

//               // --- TOMBOL REPLY DIUBAH MENJADI REPLY (INLINE) ---
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     _showInlineReply = !_showInlineReply;
//                   });
//                 },
//                 borderRadius: BorderRadius.circular(8),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 4,
//                     horizontal: 8,
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.reply_rounded,
//                         size: 20,
//                         color: _showInlineReply
//                             ? const Color(0xFF7918F2)
//                             : Colors.grey[500],
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         "Reply",
//                         style: TextStyle(
//                           color: _showInlineReply
//                               ? const Color(0xFF7918F2)
//                               : Colors.grey[600],
//                           fontSize: 13,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           // --- KOLOM INPUT INLINE REPLY ---
//           if (_showInlineReply)
//             Container(
//               margin: const EdgeInsets.only(top: 12),
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF9F9F9),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: const Color(0xFFF0F0F0)),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _replyController,
//                       style: const TextStyle(fontSize: 13),
//                       decoration: const InputDecoration(
//                         hintText: "Balas postingan ini ...",
//                         border: InputBorder.none,
//                         isDense: true,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed:
//                         _sendInlineQuoteReply, // Memanggil fungsi Quote Reply
//                     icon: const Icon(
//                       Icons.send_rounded,
//                       color: Color(0xFF7918F2),
//                       size: 18,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // --- MODAL KOMENTAR (TIDAK BERUBAH) ---
// class _CommentModal extends StatefulWidget {
//   final String postId;
//   final CommunityService service;

//   const _CommentModal({required this.postId, required this.service});

//   @override
//   State<_CommentModal> createState() => _CommentModalState();
// }

// class _CommentModalState extends State<_CommentModal> {
//   final TextEditingController _commentController = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   String? _replyToCommentId;
//   String? _replyToUsername;

//   void _startReply(String commentId, String username) {
//     setState(() {
//       _replyToCommentId = commentId;
//       _replyToUsername = username;
//     });
//     _focusNode.requestFocus();
//   }

//   void _cancelReply() {
//     setState(() {
//       _replyToCommentId = null;
//       _replyToUsername = null;
//     });
//     _focusNode.unfocus();
//   }

//   void _sendComment() async {
//     final text = _commentController.text;
//     if (text.trim().isEmpty) return;
//     _commentController.clear();
//     FocusScope.of(context).unfocus();
//     if (_replyToCommentId != null) {
//       await widget.service.addReply(widget.postId, _replyToCommentId!, text);
//       _cancelReply();
//     } else {
//       await widget.service.addComment(widget.postId, text);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.7,
//       minChildSize: 0.5,
//       maxChildSize: 0.95,
//       builder: (_, controller) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[300],
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const Text(
//                 "Komentar",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               const SizedBox(height: 10),
//               const Divider(height: 1),
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: widget.service.getCommentsStream(widget.postId),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData)
//                       return const Center(child: CircularProgressIndicator());
//                     final docs = snapshot.data!.docs;
//                     if (docs.isEmpty)
//                       return Center(
//                         child: Text(
//                           "Jadilah yang pertama berkomentar!",
//                           style: TextStyle(color: Colors.grey[400]),
//                         ),
//                       );
//                     return ListView.builder(
//                       controller: controller,
//                       itemCount: docs.length,
//                       itemBuilder: (context, index) {
//                         final data = docs[index].data() as Map<String, dynamic>;
//                         final commentId = docs[index].id;
//                         final replies = data['replies'] as List<dynamic>? ?? [];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 12,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _CommentItem(
//                                 username: data['username'] ?? 'User',
//                                 content: data['content'] ?? '',
//                                 isReply: false,
//                                 onReplyTap: () => _startReply(
//                                   commentId,
//                                   data['username'] ?? 'User',
//                                 ),
//                               ),
//                               if (replies.isNotEmpty)
//                                 Padding(
//                                   padding: const EdgeInsets.only(
//                                     left: 40,
//                                     top: 8,
//                                   ),
//                                   child: Column(
//                                     children: replies
//                                         .map(
//                                           (r) => _CommentItem(
//                                             username: r['username'],
//                                             content: r['content'],
//                                             isReply: true,
//                                             onReplyTap: null,
//                                           ),
//                                         )
//                                         .toList(),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.fromLTRB(
//                   16,
//                   12,
//                   16,
//                   MediaQuery.of(context).viewInsets.bottom + 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 5,
//                       offset: const Offset(0, -2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     if (_replyToUsername != null)
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         margin: const EdgeInsets.only(bottom: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             Text(
//                               "Membalas @$_replyToUsername",
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.purple,
//                               ),
//                             ),
//                             const Spacer(),
//                             GestureDetector(
//                               onTap: _cancelReply,
//                               child: const Icon(
//                                 Icons.close,
//                                 size: 16,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     Row(
//                       children: [
//                         const CircleAvatar(
//                           radius: 16,
//                           backgroundColor: Color(0xFFFFF3E0),
//                           child: Icon(
//                             Icons.face,
//                             size: 20,
//                             color: Colors.orange,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: TextField(
//                             controller: _commentController,
//                             focusNode: _focusNode,
//                             decoration: InputDecoration(
//                               hintText: _replyToUsername != null
//                                   ? "Tulis balasan..."
//                                   : "Tulis komentar...",
//                               border: InputBorder.none,
//                               isDense: true,
//                             ),
//                           ),
//                         ),
//                         IconButton(
//                           onPressed: _sendComment,
//                           icon: const Icon(
//                             Icons.send_rounded,
//                             color: Colors.purple,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _CommentItem extends StatelessWidget {
//   final String username;
//   final String content;
//   final bool isReply;
//   final VoidCallback? onReplyTap;

//   const _CommentItem({
//     required this.username,
//     required this.content,
//     required this.isReply,
//     this.onReplyTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(
//           radius: isReply ? 12 : 16,
//           backgroundColor: Colors.grey[200],
//           child: Icon(
//             Icons.person,
//             size: isReply ? 16 : 20,
//             color: Colors.grey,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     username,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13,
//                     ),
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     "• Baru",
//                     style: TextStyle(color: Colors.grey[500], fontSize: 11),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 2),
//               Text(content, style: const TextStyle(fontSize: 14)),
//               if (!isReply)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 4),
//                   child: GestureDetector(
//                     onTap: onReplyTap,
//                     child: Text(
//                       "Reply",
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
