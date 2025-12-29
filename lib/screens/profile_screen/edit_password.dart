import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/widgets/field_edit_profile.dart';

class EditPassword extends StatefulWidget {
  final AuthController auth;
  const EditPassword({super.key, required this.auth});

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        24,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                "Edit Password",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 14),

              FieldEditProfile(
                controller: newPasswordController,
                label: "New Password",
                validator: (value) {
                  if (value != null && value.isNotEmpty && value.length < 6) {
                    return "Enter minimal 6 character";
                  }
                  return null;
                },
              ),
              FieldEditProfile(
                controller: oldPasswordController,
                label: "Old Password",
                validator: (value) {
                  if (newPasswordController.text.isNotEmpty &&
                      (value == null || value.isEmpty)) {
                    return "Enter your old password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5A7863),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: widget.auth.isLoading
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        try {
                          await widget.auth.updatePassword(
                            oldPasswordController.text.trim(),
                            newPasswordController.text.trim(),
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Password updated')),
                          );
                        } catch (e) {
                          print(e);
                          // Navigator.pop(context);
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                child: widget.auth.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Apply Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Forget password? ",
                    style: GoogleFonts.bricolageGrotesque(
                      color: Color(0xFF6b7328),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Reset password",
                      style: GoogleFonts.bricolageGrotesque(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
