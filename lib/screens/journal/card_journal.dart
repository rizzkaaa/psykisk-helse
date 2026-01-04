import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/journal_model.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/widgets/confirm_dialog.dart';

class CardJournal extends StatefulWidget {
  final JournalModel journal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isPublic;
  const CardJournal({
    super.key,
    required this.journal,
    required this.onDelete,
    required this.onEdit,
    required this.isPublic,
  });

  @override
  State<CardJournal> createState() => _CardJournalState();
}

class _CardJournalState extends State<CardJournal> {
  final AuthController _authController = AuthController();
  late Future<UserModel?> userData;

  @override
  void initState() {
    super.initState();
    userData = _authController.fetchUserByID(widget.journal.idUser);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF73a664)),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "There's no user",
              style: TextStyle(color: Color(0xFF73a664)),
            ),
          );
        } else {
          final user = snapshot.data!;
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                decoration: inset.BoxDecoration(
                  color: Colors.white,
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
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFF5A7863), width: 3),
                    ),
                    child: CircleAvatar(
                      backgroundImage: (user.photo.toString().isNotEmpty)
                          ? user.photo.toImageProvider()
                          : AssetImage('assets/images/default-ava.png')
                                as ImageProvider,
                    ),
                  ),
                  title: Text(
                    widget.journal.title,
                    style: GoogleFonts.bricolageGrotesque(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Creator: @${user.username}",
                    style: GoogleFonts.bricolageGrotesque(color: Colors.grey),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 20,
                ),
                decoration: inset.BoxDecoration(
                  boxShadow: [
                    inset.BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 3,
                      offset: Offset(3, -2),
                      inset: true,
                    ),
                    inset.BoxShadow(
                      color: Colors.white.withOpacity(0.5),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.journal.createdAt.toFormattedDate(),
                      style: GoogleFonts.modernAntiqua(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),

                    if (!widget.isPublic)
                      Row(
                        children: [
                          IconButton(
                            onPressed: widget.onEdit,
                            icon: Icon(
                              Icons.edit_note_outlined,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return ConfirmDialog(
                                    title:
                                        "Are you sure you want to delete this journal?",
                                    onConfirm: widget.onDelete,
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.delete, color: Colors.white),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
