import 'package:flutter/material.dart';
import 'package:uas_project/models/journal_model.dart';
import 'package:uas_project/screens/journal/card_journal.dart';
import 'package:uas_project/screens/journal/journal_screen.dart';
import 'package:uas_project/services/journal_service.dart';

class BookmarkJournalContent extends StatefulWidget {
  final bool isBookmarked;
  final String idUser;
  const BookmarkJournalContent({
    super.key,
    required this.isBookmarked,
    required this.idUser,
  });

  @override
  State<BookmarkJournalContent> createState() => _BookmarkJournalContentState();
}

class _BookmarkJournalContentState extends State<BookmarkJournalContent> {
  final JournalService _journalService = JournalService();
  late Future<List<JournalModel>> journalData;

  @override
  void initState() {
    super.initState();
    _loadJournal();
  }

  void _loadJournal() {
    if (widget.isBookmarked) {
      journalData = _journalService.getBookmarkedJournal(widget.idUser);
    } else {
      journalData = _journalService.getAllJournalByUser(idUser: widget.idUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FutureBuilder(
          future: journalData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF73a664)),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text("Error fetch journal: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "There's no journal",
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              final journals = snapshot.data!;

              return ListView.builder(
                itemCount: journals.length,
                itemBuilder: (context, index) {
                  final journal = journals[index];
                  if (journal.isPublic) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JournalScreen(journal: journal),
                        ),
                      ),
                      child: CardJournal(
                        journal: journal,
                        onEdit: () {},
                        isPublic: true,
                        onDelete: () {},
                      ),
                    );
                  }else {
                    return SizedBox();
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
