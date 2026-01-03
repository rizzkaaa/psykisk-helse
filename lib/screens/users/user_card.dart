import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/widgets/confirm_dialog.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class UserCard extends StatelessWidget {
  final UserModel user;
  final UserModel currentUser;
  final VoidCallback onConfirmAction;
  final VoidCallback onConfirmDelete;
  const UserCard({super.key, required this.user, required this.currentUser, required this.onConfirmAction, required this.onConfirmDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: CircleAvatar(
                backgroundImage: (user.photo.toString().isNotEmpty)
                    ? user.photo.toImageProvider()
                    : AssetImage('assets/images/default-ava.png')
                          as ImageProvider,
              ),
            ),
            title: Text(
              "@${user.username}",
              style: GoogleFonts.bricolageGrotesque(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              user.email,
              style: GoogleFonts.bricolageGrotesque(color: Colors.white70),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.displayRole,
                style: GoogleFonts.modernAntiqua(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),

              user.docId! == currentUser.docId
                  ? Text(
                      "(Anda)",
                      style: GoogleFonts.modernAntiqua(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )
                  : !user.isActive
                  ? Text(
                      "(Inactive)",
                      style: GoogleFonts.modernAntiqua(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )
                  : Row(
                      children: [
                        if (user.role != 'counsultant')
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return ConfirmDialog(
                                    title: user.role == 'user'
                                        ? "Are you sure you want to promote this user to admin?"
                                        : "Are you sure you want to demote this admin to a regular user?",
                                    onConfirm: onConfirmAction
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              user.role == 'user'
                                  ? Icons.person_add_rounded
                                  : Icons.person_remove_rounded,
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
                                      "Are you sure you want to ban this user?",
                                  onConfirm: onConfirmDelete
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
}
