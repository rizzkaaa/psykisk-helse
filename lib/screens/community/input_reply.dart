import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/models/reply_post_model.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/services/community_service.dart';

class InputReply extends StatefulWidget {
  final String postId;
  final ReplyPost replyParent;
  final VoidCallback clearReply;
  const InputReply({
    super.key,
    required this.postId,
    required this.replyParent,
    required this.clearReply,
  });

  @override
  State<InputReply> createState() => _InputReplyState();
}

class _InputReplyState extends State<InputReply> {
  final CommunityService _communityService = CommunityService();
  final AuthController _authController = AuthController();
  late Future<UserModel?> userData;
  final TextEditingController _replyController = TextEditingController();
  String? userID;
  String? userLevel;

  @override
  void initState() {
    super.initState();
    userData = _authController.fetchUserByID(widget.replyParent.idUser);
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
          final userParent = snapshot.data!;

          return Container(
            decoration: inset.BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              color: Color(0xFF73a664),
              boxShadow: [
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(0, 2),
                  inset: true,
                ),
              ],
            ),

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reply @${userParent.username}",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
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
                            postId: widget.postId,
                            content: _replyController.text.trim(),
                            idUser: userID!,
                            role: userLevel!,
                            parentUserID: widget.replyParent.idUser,
                            idReply: widget.replyParent.id,
                          );
                          _replyController.clear();
                          widget.clearReply();
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
          );
        }
      },
    );
  }
}
