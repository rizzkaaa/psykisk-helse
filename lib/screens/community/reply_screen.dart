import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/reply_post_model.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/widgets/unstyle_button.dart';

class ReplyScreen extends StatefulWidget {
  final ReplyPost reply;
  final VoidCallback onPressed;
  final bool isReplyFieldOpen;
  final bool isComment;
  final String? parentUserName;

  const ReplyScreen({
    super.key,
    required this.reply,
    required this.onPressed,
    required this.isReplyFieldOpen,
    this.isComment = true,
    this.parentUserName,
  });

  @override
  State<ReplyScreen> createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  final TextEditingController _replyController = TextEditingController();
  final AuthController _authController = AuthController();
  late Future<UserModel?> userData;
  Future<UserModel?>? parentUserData; // Tambah ini untuk parent user

  @override
  void initState() {
    super.initState();
    userData = _authController.fetchUserByID(widget.reply.idUser);
    if (!widget.isComment &&
        widget.parentUserName != null &&
        widget.parentUserName!.isNotEmpty) {
      parentUserData = _authController.fetchUserByID(widget.parentUserName!);
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
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
          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                if (!widget.isComment)
                  Column(
                    children: [
                      const SizedBox(width: 10),
                      Icon(
                        Icons.subdirectory_arrow_right_rounded,
                        color: Color(0xFF73a664),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),

                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF73a664),
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: (user.photo.toString().isNotEmpty)
                              ? user.photo.toImageProvider()
                              : AssetImage('assets/images/default-ava.png')
                                    as ImageProvider,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!widget.isComment &&
                                        parentUserData != null)
                                      FutureBuilder<UserModel?>(
                                        future: parentUserData,
                                        builder: (context, parentSnapshot) {
                                          if (parentSnapshot.hasData &&
                                              parentSnapshot.data != null) {
                                            return Text(
                                              "Reply @${parentSnapshot.data!.username}",
                                              style: GoogleFonts.roboto(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            );
                                          }
                                          return SizedBox.shrink();
                                        },
                                      ),

                                    Text(
                                      "@${user.username} ${widget.reply.displayRole}",
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // Timestamp
                                    Row(
                                      children: [
                                        Text(
                                          widget.reply.timestamp.timeAgo,
                                          style: GoogleFonts.bricolageGrotesque(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Content
                            Text(
                              widget.reply.content,
                              style: GoogleFonts.bricolageGrotesque(),
                              textAlign: TextAlign.justify,
                            ),

                            // Reply button
                            UnstyleButton(
                              onPressed: widget.onPressed,
                              content: Row(
                                children: [
                                  widget.isReplyFieldOpen
                                      ? Icon(
                                          Icons.close_rounded,
                                          color: Colors.black,
                                          size: 20,
                                        )
                                      : Icon(
                                          Icons.reply,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.isReplyFieldOpen
                                        ? "Cancel"
                                        : "Reply",
                                    style: GoogleFonts.bricolageGrotesque(
                                      color: Colors.black,
                                      fontSize: 12,
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
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
