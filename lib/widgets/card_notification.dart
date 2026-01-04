import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class CardNotification extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const CardNotification({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              children: [
                Row(
                  children: [
                    Text(
                      "sender:",
                      style: GoogleFonts.bricolageGrotesque(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Sistem",
                      style: GoogleFonts.bricolageGrotesque(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        notification['title'],
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: Icon(Icons.delete, color: Colors.white),
                    ),
                  ],
                ),
              ],
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
            child: Text(
              (notification['time'] as Timestamp).timeAgoTimestamp,
              style: GoogleFonts.modernAntiqua(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
