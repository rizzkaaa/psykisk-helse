import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/models/journal_model.dart';
import 'package:uas_project/screens/journal/journal_screen.dart';
import 'package:uas_project/services/journal_service.dart';
import 'package:uas_project/widgets/unstyle_button.dart';

class CreateJournal extends StatefulWidget {
  final JournalModel? journal;
  const CreateJournal({super.key, this.journal});

  @override
  State<CreateJournal> createState() => _CreateJournalState();
}

class _CreateJournalState extends State<CreateJournal> {
  final JournalService _journalService = JournalService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool isPublic = false;
  final UndoHistoryController _undoController = UndoHistoryController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.journal == null
        ? "My Journal"
        : widget.journal!.title;
    _contentController.text = widget.journal == null
        ? ""
        : widget.journal!.content;
    isPublic = widget.journal == null ? false : widget.journal!.isPublic;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _undoController.dispose();
    super.dispose();
  }

  void _saveJournal(String idUser) async {
    if (_contentController.text.isEmpty) return;

    try {
      late JournalModel journal;

      if (widget.journal == null) {
        journal = await _journalService.addJournal(
          idUser: idUser,
          title: _titleController.text,
          content: _contentController.text,
          isPublic: isPublic,
        );
      } else {
        journal = await _journalService.editJournal(
          idJournal: widget.journal!.docId!,
          title: _titleController.text,
          content: _contentController.text,
          isPublic: isPublic,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.journal == null ? "Journal created" : "Journal updated",
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => JournalScreen(journal: journal)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload journal failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

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
                  onPressed: () => Navigator.pop(context),
                  tooltip: "Back",
                ),
              ],
            ),
          ),
        ],
      ),
      body: auth.userData == null
          ? Center(child: CircularProgressIndicator(color: Color(0xFF73a664)))
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  decoration: inset.BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
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
                            const Icon(
                              Icons.create_outlined,
                              color: Colors.white,
                              size: 40,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _titleController,
                                style: GoogleFonts.modernAntiqua(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ValueListenableBuilder<UndoHistoryValue>(
                        valueListenable: _undoController,
                        builder: (context, value, _) {
                          return Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.undo,
                                  color: value.canUndo
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                                onPressed: value.canUndo
                                    ? () => _undoController.undo()
                                    : null,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.redo,
                                  color: value.canRedo
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                                onPressed: value.canRedo
                                    ? () => _undoController.redo()
                                    : null,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      undoController: _undoController,
                      controller: _contentController,
                      maxLines: 100,
                      maxLength: 2500,
                      style: GoogleFonts.bricolageGrotesque(),
                      decoration: InputDecoration(
                        hint: Text(
                          "Type everything you want...",
                          style: GoogleFonts.bricolageGrotesque(
                            color: Colors.grey,
                          ),
                        ),
                        counterStyle: GoogleFonts.bricolageGrotesque(
                          color: Color(0xFF73a664),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: inset.BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isPublic,
                            onChanged: (value) {
                              setState(() {
                                isPublic = value!;
                              });
                            },
                            shape: CircleBorder(),
                            activeColor: Colors.white,
                            checkColor: Color(0xFF5C8374),
                          ),
                          Text(
                            "Show to public",
                            style: GoogleFonts.bricolageGrotesque(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      UnstyleButton(
                        onPressed: () => _saveJournal(auth.userData!.docId!),
                        content: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: inset.BoxDecoration(
                            shape: BoxShape.circle,
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
                          child: const Icon(
                            Icons.send_rounded,
                            color: Color(0xFF73a664),
                            size: 22,
                          ),
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
