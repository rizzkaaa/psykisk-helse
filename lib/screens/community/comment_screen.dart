import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:uas_project/models/reply_post_model.dart';
import 'package:uas_project/screens/community/input_reply.dart';
import 'package:uas_project/screens/community/reply_screen.dart';
import 'package:uas_project/services/community_service.dart';

class CommentScreen extends StatefulWidget {
  final String idPost;
  const CommentScreen({super.key, required this.idPost});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late Stream<List<Map<String, dynamic>>> repliesData;
  final CommunityService _communityService = CommunityService();
  ReplyPost? replyParent;

  @override
  void initState() {
    super.initState();
    repliesData = _communityService.getRepliesStream(widget.idPost);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: repliesData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              
              final commentThreads = snapshot.data ?? [];
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    thickness: 5,
                    color: Colors.grey.shade400,
                    indent: 150,
                    endIndent: 150,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "Comment",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Divider(thickness: 2, color: Colors.black),
                  const SizedBox(height: 20),

                  if (commentThreads.isEmpty)
                    Center(
                      child: Text(
                        "There's no comment",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                  if (commentThreads.isNotEmpty)
                    Container(
                      height: 400,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView.builder(
                        itemCount: commentThreads.length,
                        itemBuilder: (context, index) {
                          final thread = commentThreads[index];
                          final comment = thread['comment'] as ReplyPost;
                          final replies = thread['replies'] as List<ReplyPost>;
                          
                          return _buildCommentThread(comment, replies, setModalState);
                        },
                      ),
                    ),

                  const SizedBox(height: 20),

                  if (replyParent != null)
                    InputReply(
                      postId: widget.idPost,
                      replyParent: replyParent!,
                      clearReply: () {
                        setModalState(() {
                          replyParent = null;
                        });
                      },
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCommentThread(
  ReplyPost comment,
  List<ReplyPost> replies,
  StateSetter setModalState,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Level 1: Comment ke Post (tanpa indentasi)
      ReplyScreen(
        reply: comment,
        onPressed: () {
          setModalState(() {
            if (replyParent?.id == comment.id) {
              replyParent = null;
            } else {
              replyParent = comment;
            }
          });
        },
        isReplyFieldOpen: replyParent?.id == comment.id,
        isComment: true, // Ini level 1 (comment)
      ),
      
      // Level 2: Replies dengan indentasi
      if (replies.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 40), // Indentasi untuk level 2
          child: Column(
            children: replies.map((reply) {
              return ReplyScreen(
                reply: reply,
                onPressed: () {
                  setModalState(() {
                    if (replyParent?.id == reply.id) {
                      replyParent = null;
                    } else {
                      replyParent = reply;
                    }
                  });
                },
                isReplyFieldOpen: replyParent?.id == reply.id,
                isComment: false, // Ini level 2 (reply)
                parentUserName: reply.parentUserID, // Username yang direply
              );
            }).toList(),
          ),
        ),
      
      const SizedBox(height: 10), // Spacing antar thread
    ],
  );
}
}
