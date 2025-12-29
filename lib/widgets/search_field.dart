import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchField extends StatefulWidget {
  final VoidCallback onPressed;

  const SearchField({super.key, required this.onPressed});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _searchController = TextEditingController();

  void _clearSearch() {
    setState(() {
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
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
        _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: _clearSearch,
                icon: Icon(
                  Icons.close,
                  color: Color(0xFF73a664),
                  fontWeight: FontWeight.bold,
                ),
              )
            : IconButton(
                onPressed: widget.onPressed,
                icon: Icon(
                  Icons.search,
                  color: Color(0xFF73a664),
                  fontWeight: FontWeight.bold,
                ),
              ),
      ],
    );
  }
}
