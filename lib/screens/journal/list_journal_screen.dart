import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/models/journal_model.dart';
import 'package:uas_project/screens/journal/card_journal.dart';
import 'package:uas_project/screens/journal/journal_screen.dart';
import 'package:uas_project/services/journal_service.dart';
import 'package:uas_project/widgets/search_field.dart';
import 'package:uas_project/widgets/tab_menu_profile.dart';

class ListJournalScreen extends StatefulWidget {
  const ListJournalScreen({super.key});

  @override
  State<ListJournalScreen> createState() => _ListJournalScreenState();
}

class _ListJournalScreenState extends State<ListJournalScreen> {
  final JournalService _journalService = JournalService();
  late Future<List<JournalModel>> journalData;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool isPublic = true;

  @override
  void initState() {
    super.initState();
    _loadJournal();
  }

  void _loadJournal() {
    final auth = context.read<AuthController>();
    if (auth.userData == null) return;
    setState(() {
      if (_searchQuery.isEmpty) {
        isPublic
            ? journalData = _journalService.getAllJournalPublic()
            : journalData = _journalService.getAllJournalByUser(
                idUser: auth.userData!.docId!,
              );
      } else {
        print(_searchQuery);
        journalData = _journalService.searchJournal(
          isPublic: isPublic,
          query: _searchQuery,
          idUser: auth.userData!.docId
        );
      }
    });
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    setState(() {
      _searchQuery = query;
    });
    print(_searchQuery);
    _loadJournal();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
    });
    _loadJournal();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reloadData() {
    final auth = context.read<AuthController>();
    if (auth.userData == null) return;
    setState(() {
      isPublic
          ? journalData = _journalService.getAllJournalPublic()
          : journalData = _journalService.getAllJournalByUser(
              idUser: auth.userData!.docId!,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A7863),
      appBar: AppBar(
        backgroundColor: Color(0xFF73a664),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.edit_square, color: Colors.white, size: 40),
            const SizedBox(width: 8),
            Text(
              "Journal",
              style: GoogleFonts.modernAntiqua(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        centerTitle: false,
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
                  onPressed: () => Navigator.pop(context),
                  tooltip: "Back",
                ),

                IconButton(
                  icon: const Icon(Icons.refresh, color: Color(0xFF73a664)),
                  onPressed: () => _reloadData(),
                  tooltip: "Refresh",
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: inset.BoxDecoration(
                borderRadius: BorderRadius.circular(30),
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
              child: SearchField(
                onSubmitted: (value) => _performSearch(),
                onClear: _clearSearch,
                controller: _searchController,
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isPublic == false) {
                        isPublic = true;
                        _reloadData();
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: isPublic ? Colors.white : Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.public,
                          color: isPublic ? Color(0xFF4A7C7E) : Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Public",
                          style: GoogleFonts.bricolageGrotesque(
                            color: isPublic ? Color(0xFF4A7C7E) : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isPublic == true) {
                        isPublic = false;
                        _reloadData();
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: !isPublic ? Colors.white : Colors.transparent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock,
                          color: !isPublic ? Color(0xFF4A7C7E) : Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Personal",
                          style: GoogleFonts.bricolageGrotesque(
                            color: !isPublic ? Color(0xFF4A7C7E) : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF90AB8B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FutureBuilder(
                  future: journalData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF73a664),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
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
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    JournalScreen(journal: journal),
                              ),
                            ),
                            child: CardJournal(journal: journal),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/createJournal"),
        backgroundColor: Color(0xFF73a664),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
