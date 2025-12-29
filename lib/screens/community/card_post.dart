import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/post_model.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/screens/community/comment_screen.dart';
import 'package:uas_project/services/community_service.dart';
import 'package:uas_project/widgets/unstyle_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class CardPost extends StatefulWidget {
  final PostModel post;
  const CardPost({super.key, required this.post});

  @override
  State<CardPost> createState() => _CardPostState();
}

class _CardPostState extends State<CardPost> {
  bool isReplyFieldOpen = false;
  final TextEditingController _replyController = TextEditingController();
  final AuthController _authController = AuthController();
  final CommunityService _communityService = CommunityService();
  late UserModel user;
  late Future<UserModel?> userData;
  bool isLiked = false;
  String? userID;
  String? userLevel;

  @override
  void initState() {
    super.initState();
    userData = _authController.fetchUserByID(widget.post.idUser);
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userId');
    final level = prefs.getString('userLevel');

    setState(() {
      userID = uid;
      userLevel = level;
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _checkIsLiked() async {
    final liked = await _communityService.isPostLiked(
      userID!,
      widget.post.id,
    );

    if (mounted) {
      setState(() {
        isLiked = liked;
      });
    }
  }

  void _showComment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFEBF4DD),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
      ),
      builder: (context) {
        return CommentScreen(idPost: widget.post.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(child: Text("Tidak ada data"));
        } else {
          user = snapshot.data!;
          _checkIsLiked();

          return Padding(
            padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  decoration: inset.BoxDecoration(
                    color: const Color(0xFF252A34),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      inset.BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: Offset(3, 2),
                        inset: true,
                      ),
                      inset.BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 3,
                        offset: Offset(-3, 2),
                        inset: true,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: CircleAvatar(
                              backgroundImage: (user.photo.isNotEmpty)
                                  ? user.photo.toImageProvider()
                                  : AssetImage(
                                          'assets/images/default-ava.png',
                                        )
                                        as ImageProvider,
                            ),
                          ),

                          const SizedBox(width: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "@${user.username} ${widget.post.displayRole}",
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.post.timestamp.timeAgo,
                                    style: GoogleFonts.bricolageGrotesque(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      widget.post.tag,
                                      style: GoogleFonts.bricolageGrotesque(
                                        color: Color(0xFF4ece5d),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        thickness: 2,
                        color: Colors.white,
                        radius: BorderRadius.circular(20),
                      ),
                      Text(
                        widget.post.content,
                        style: GoogleFonts.bricolageGrotesque(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: inset.BoxDecoration(
                    boxShadow: [
                      inset.BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: Offset(3, -2),
                        inset: true,
                      ),
                      inset.BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 3,
                        offset: Offset(-3, -2),
                        inset: true,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color(0xFFacc990),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              UnstyleButton(
                                onPressed: () async {
                                  await _communityService.likePost(
                                    userID!,
                                    widget.post.id,
                                    !isLiked,
                                  );
                                  _checkIsLiked();
                                },
                                content: Row(
                                  children: [
                                    Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isLiked
                                          ? Colors.red
                                          : Colors.white,
                                      size: 25,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${widget.post.likes}",
                                      style: GoogleFonts.bricolageGrotesque(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              UnstyleButton(
                                onPressed: _showComment,
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "${widget.post.comments}",
                                      style: GoogleFonts.bricolageGrotesque(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          UnstyleButton(
                            onPressed: () {
                              setState(() {
                                isReplyFieldOpen = !isReplyFieldOpen;
                              });
                            },
                            content: Row(
                              children: [
                                isReplyFieldOpen
                                    ? Icon(
                                        Icons.close_rounded,
                                        color: Colors.white,
                                        size: 25,
                                      )
                                    : Icon(
                                        Icons.reply,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                const SizedBox(width: 5),
                                Text(
                                  isReplyFieldOpen ? "Cancel" : "Reply",
                                  style: GoogleFonts.bricolageGrotesque(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (isReplyFieldOpen)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.symmetric(vertical: 10),
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
                              Expanded(
                                child: TextField(
                                  controller: _replyController,
                                  decoration: InputDecoration(
                                    hint: Text(
                                      "Reply this post...",
                                      style: GoogleFonts.bricolageGrotesque(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: GoogleFonts.bricolageGrotesque(),
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await _communityService.addReply(
                                    postId: widget.post.id,
                                    content: _replyController.text.trim(),
                                    idUser: userID!,
                                    role: userLevel!,
                                  );
                                  _replyController.clear();
                                  isReplyFieldOpen = false;
                                },
                                icon: Icon(
                                  Icons.send_rounded,
                                  color: Color(0xFF73a664),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
