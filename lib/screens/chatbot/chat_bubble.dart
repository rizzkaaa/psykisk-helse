import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({super.key, required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.70,
        ),
        padding: const EdgeInsets.all(16),
        decoration: inset.BoxDecoration(
          color: isUser ? Color(0xFFacc990) : Color(0xFF2B303A),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(40),
            topRight: const Radius.circular(40),
            bottomLeft: isUser
                ? const Radius.circular(40)
                : const Radius.circular(2),
            bottomRight: isUser
                ? const Radius.circular(2)
                : const Radius.circular(40),
          ),
          boxShadow: [
            inset.BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 3,
              offset: Offset(3, 2),
              inset: true,
            ),
            inset.BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 3,
              offset: Offset(-3, -2),
              inset: true,
            ),
          ],
        ),
        child: isUser
            ? Text(
                message,
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white,
                  fontSize: 16,
                ),
              )
            : MarkdownBody(
                data: message,
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.bricolageGrotesque(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  strong: GoogleFonts.bricolageGrotesque(
                    color: Color(0xFFacc990),
                    fontWeight: FontWeight.bold,
                  ),
                  listBullet: GoogleFonts.bricolageGrotesque(
                    color: Color(0xFFacc990),
                  ),
                ),
              ),
      ),
    );
  }
}
