import 'package:flutter/material.dart';

class FieldEditProfile extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final int? maxLines;

  const FieldEditProfile({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.maxLines,
  });

  @override
  State<FieldEditProfile> createState() => _FieldEditProfileState();
}

class _FieldEditProfileState extends State<FieldEditProfile> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField =
        widget.label == "New Password" || widget.label == "Old Password";

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        obscureText: isPasswordField ? _obscurePassword : false,
        controller: widget.controller,
        maxLines: widget.maxLines ?? 1,
        validator: widget.validator,
        decoration: InputDecoration(
          label: Text(
            widget.label,
            style: TextStyle(
              color: Color(0xFF5A7863),
              fontWeight: FontWeight.bold,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPasswordField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Color(0xFF818945),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
