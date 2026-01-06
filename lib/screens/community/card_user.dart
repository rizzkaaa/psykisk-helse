import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/screens/profile/profile_screen.dart';

class CardUser extends StatelessWidget {
  final UserModel user;
  const CardUser({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(selectUser: user),
          ),
        );
      },
      child: Column(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
