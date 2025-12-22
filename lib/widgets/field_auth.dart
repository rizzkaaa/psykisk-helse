import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FieldAuth extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final String? Function(String?)? validator;

  const FieldAuth({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.validator,
  });

  @override
  State<FieldAuth> createState() => _FieldAuthState();
}

class _FieldAuthState extends State<FieldAuth> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField =
        widget.label == "Password" || widget.label == "Confirm Password";
    return TextFormField(
      obscureText: isPasswordField ? _obscurePassword : false,
      controller: widget.controller,
      style: GoogleFonts.bricolageGrotesque(color: Color(0xFF6b7328)),
      decoration: InputDecoration(
        icon: Icon(widget.icon, size: 30, color: Color(0xFF6b7328)),
        label: Text(
          widget.label,
          style: GoogleFonts.bricolageGrotesque(
            color: Color(0xFF6b7328),
            fontWeight: FontWeight.bold,
          ),
        ),
        fillColor: Color(0xFFdad6b0).withOpacity(0.4),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF818945), width: 3),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF818945), width: 3),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
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
      validator: widget.validator,
    );
  }
}
