import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const SearchField({
    super.key,
    required this.onSubmitted,
    required this.onClear,
    required this.controller,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            onSubmitted: widget.onSubmitted,
            onChanged: (value) {
              if(value.isEmpty){
                widget.onClear();
              }
            },
            decoration: InputDecoration(
              hint: Text(
                "Search...",
                style: GoogleFonts.bricolageGrotesque(color: Colors.grey),
              ),
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
            style: GoogleFonts.bricolageGrotesque(),
          ),
        ),
        widget.controller.text.isNotEmpty
            ? IconButton(
                onPressed: widget.onClear,
                icon: Icon(
                  Icons.close,
                  color: Color(0xFF73a664),
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(
                Icons.search,
                color: Color(0xFF73a664),
                fontWeight: FontWeight.bold,
              ),
      ],
    );
  }
}
