import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/models/journal_model.dart';
import 'package:uas_project/services/journal_service.dart';

class JournalScreen extends StatefulWidget {
  final JournalModel journal;
  const JournalScreen({super.key, required this.journal});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final JournalService _journalService = JournalService();
  bool _isBookmarked = false;
  bool _loadingBookmark = true;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  Future<void> _checkBookmark() async {
    final auth = context.read<AuthController>();
    if (auth.userData == null) return;

    final result = await _journalService.isJournalBookmarked(
      auth.userData!.docId!,
      widget.journal.docId!,
    );

    if (!mounted) return;
    setState(() {
      _isBookmarked = result;
      _loadingBookmark = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBF4DD),
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
                  onPressed: () => Navigator.pushNamed(context, "/listJournal"),
                  tooltip: "Back",
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
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.book, color: Colors.white, size: 40),
                      const SizedBox(width: 8),
                      Text(
                        widget.journal.title,
                        style: GoogleFonts.modernAntiqua(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),

                _loadingBookmark
                    ? const CircularProgressIndicator(color: Colors.white)
                    : IconButton(
                        onPressed: () async {
                          final auth = context.read<AuthController>();
                          if (auth.userData == null) return;

                          await _journalService.bookmarkJournal(
                            auth.userData!.docId!,
                            widget.journal.docId!,
                          );

                          setState(() {
                            _isBookmarked = !_isBookmarked;
                          });
                        },
                        icon: Icon(
                          _isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Colors.white,
                        ),
                      ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.journal.content,
                style: GoogleFonts.bricolageGrotesque(),
                textAlign: TextAlign.justify,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
