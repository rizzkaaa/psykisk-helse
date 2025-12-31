import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_project/models/journal_model.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  // --- DATABASE DOKUMEN ---
  List<DocBlock> _blocks = [];
  final List<List<DocBlock>> _undoHistory = []; // Riwayat untuk Universal Undo

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController(
    text: "Your Journal",
  );
  final TextEditingController _sizeInputController = TextEditingController(
    text: "17",
  );

  TextAlign _textAlign = TextAlign.left;
  double _fontSize = 17.0;
  Color _textColor = Colors.black;
  String _fontFamily = 'Roboto';
  bool _isBold = false, _isItalic = false, _isUnderline = false;

  @override
  void initState() {
    super.initState();
    _blocks.add(DocBlock(type: 'text', controller: TextEditingController()));
    _saveToHistory();
  }

  void _saveToHistory() {
    _undoHistory.add(_blocks.map((b) => b.copy()).toList());
    if (_undoHistory.length > 50) _undoHistory.removeAt(0);
  }

  void _performUndo() {
    if (_undoHistory.length > 1) {
      setState(() {
        _undoHistory.removeLast();
        _blocks = _undoHistory.last.map((b) => b.copy()).toList();
      });
    }
  }

  // --- LOGIKA MEDIA & SMART NUMBERING ---
  void _insertImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _blocks.add(DocBlock(type: 'image', imageFile: File(file.path)));
        _blocks.add(
          DocBlock(type: 'text', controller: TextEditingController()),
        );
        _saveToHistory();
      });
    }
  }

  void _applySmartNumbering(String type) {
    setState(() {
      String lastText = _blocks.last.controller!.text;
      String next = "";

      if (type == "123") {
        int count = RegExp(r'\d+\.').allMatches(lastText).length + 1;
        next = "\n$count. ";
      } else if (type == "ABC") {
        int count = RegExp(r'[A-Z]\.').allMatches(lastText).length;
        next = "\n${String.fromCharCode(65 + count)}. ";
      } else if (type == "abc") {
        int count = RegExp(r'[a-z]\.').allMatches(lastText).length;
        next = "\n${String.fromCharCode(97 + count)}. ";
      } else {
        next = "\n• ";
      }

      _blocks.last.controller!.text += next;
      _saveToHistory();
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
                  onPressed: () => Navigator.pop(context),
                  tooltip: "Back",
                ),
                IconButton(
                  icon: const Icon(Icons.undo, color: Color(0xFF73a664)),
                  onPressed: _performUndo,
                  tooltip: "Undo",
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF73a664)),
                  onPressed: () {},
                  tooltip: "Send",
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
                    decoration: const InputDecoration(border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _blocks.length,
              itemBuilder: (context, index) {
                var block = _blocks[index];
                if (block.type == 'text') {
                  return TextField(
                    controller: block.controller,
                    maxLines: null,
                    textAlign: _textAlign,
                    onChanged: (v) => _saveToHistory(),
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: _textColor,
                      fontFamily: _fontFamily,
                      fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                      fontStyle: _isItalic
                          ? FontStyle.italic
                          : FontStyle.normal,
                      decoration: _isUnderline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Tulis dokumen...",
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () => setState(() {
                      block.widthFactor = block.widthFactor == 1.0 ? 0.5 : 1.0;
                      _saveToHistory();
                    }),
                    child: Container(
                      alignment: _textAlign == TextAlign.center
                          ? Alignment.center
                          : (_textAlign == TextAlign.right
                                ? Alignment.centerRight
                                : Alignment.centerLeft),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              block.imageFile!,
                              width:
                                  MediaQuery.of(context).size.width *
                                  block.widthFactor,
                            ),
                          ),
                          if (block.widthFactor < 1.0)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.wrap_text,
                                color: Colors.white,
                                shadows: [
                                  Shadow(blurRadius: 10, color: Colors.black),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          _buildToolbar(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      decoration: inset.BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
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

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  _toolBtn(Icons.add_photo_alternate, _insertImage),
                  _vDivider(),
                  _toolBtn(
                    Icons.format_bold,
                    () => setState(() => _isBold = !_isBold),
                    active: _isBold,
                  ),
                  _toolBtn(
                    Icons.format_italic,
                    () => setState(() => _isItalic = !_isItalic),
                    active: _isItalic,
                  ),
                  _toolBtn(
                    Icons.format_underlined,
                    () => setState(() => _isUnderline = !_isUnderline),
                    active: _isUnderline,
                  ),
                  _vDivider(),
                  const Text(
                    "Font: ",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  DropdownButton<String>(
                    dropdownColor: Colors.black,
                    value: _fontFamily,
                    underline: const SizedBox(),
                    onChanged: (v) => setState(() => _fontFamily = v!),
                    items: ['Roboto', 'serif', 'monospace']
                        .map(
                          (f) => DropdownMenuItem(
                            value: f,
                            child: Text(
                              f,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: f,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Row(
                children: [
                  _toolBtn(
                    Icons.format_align_left,
                    () => setState(() => _textAlign = TextAlign.left),
                  ),
                  _toolBtn(
                    Icons.format_align_center,
                    () => setState(() => _textAlign = TextAlign.center),
                  ),
                  _toolBtn(
                    Icons.format_align_right,
                    () => setState(() => _textAlign = TextAlign.right),
                  ),
                  _vDivider(),
                  _toolBtn(
                    Icons.format_list_bulleted,
                    () => _applySmartNumbering("bullet"),
                  ),
                  _textBtn("123", () => _applySmartNumbering("123")),
                  _textBtn("ABC", () => _applySmartNumbering("ABC")),
                  _textBtn("abc", () => _applySmartNumbering("abc")),
                  _vDivider(),
                  const Text("Size: ", style: TextStyle(fontSize: 12, color: Colors.white)),
                  SizedBox(
                    width: 35,
                    child: TextField(
                      controller: _sizeInputController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (v) => setState(
                        () => _fontSize = double.tryParse(v) ?? 17.0,
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                         color: Colors.white
                      ),
                    ),
                  ),
                  _toolBtn(Icons.palette, _showColorPicker),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolBtn(IconData icon, VoidCallback onTap, {bool active = false}) =>
      IconButton(
        icon: Icon(
          icon,
          color: active ? Colors.white : Colors.white70,
          size: 24,
        ),
        onPressed: onTap,
      );

  Widget _textBtn(String label, VoidCallback onTap) => TextButton(
    onPressed: onTap,
    child: Text(
      label,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );

  Widget _vDivider() => Container(
    height: 20,
    width: 1,
    color: Colors.white38,
    margin: const EdgeInsets.symmetric(horizontal: 8),
  );

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (c) => Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 15,
          children:
              [
                    Colors.black,
                    Colors.red,
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                  ]
                  .map(
                    (clr) => IconButton(
                      icon: CircleAvatar(backgroundColor: clr),
                      onPressed: () {
                        setState(() => _textColor = clr);
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
