import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/widgets/field_auth.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onPressed;
  const SignUpScreen({super.key, required this.onPressed});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerController = context.watch<AuthController>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Get Started",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Color(0xFF6b7328),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Divider(
          thickness: 5,
          color: Color(0xFFa7a96f),
          radius: BorderRadius.circular(20),
        ),
        const SizedBox(height: 40),
        Form(
          key: _formKey,
          child: Column(
            children: [
              FieldAuth(
                controller: _usernameController,
                label: "Username",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username can't be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              FieldAuth(
                controller: _emailController,
                label: "Email",
                icon: Icons.alternate_email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email can't be empty";
                  }
                  if (!value.contains('@')) {
                    return "Enter the valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              FieldAuth(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock_outline_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password can't be empty";
                  }
                  if (value.length < 6) {
                    return "Enter minimal 6 character";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              FieldAuth(
                controller: _confirmPasswordController,
                label: "Confirm Password",
                icon: Icons.key,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter confirm password";
                  }
                  if (value != _passwordController.text.trim()) {
                    return "Enter the correct password";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: registerController.isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          final success = await registerController.register(
                            _usernameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          );
                          if (!mounted) return;
                          
                          if (success) {
                            widget.onPressed();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(registerController.error!),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Color(0xFF818945),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Sign In",
                    style: GoogleFonts.bricolageGrotesque(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Text(
                    "Already have account? ",
                    style: GoogleFonts.bricolageGrotesque(
                      color: Color(0xFF6b7328),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onPressed     ,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      "Sign In Now",
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
        const SizedBox(height: 25),

        Divider(thickness: 3, color: Colors.grey, indent: 130, endIndent: 130),
      ],
    );
  }
}
