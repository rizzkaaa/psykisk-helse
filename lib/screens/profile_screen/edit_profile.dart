import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/widgets/field_edit_profile.dart';

class EditProfile extends StatefulWidget {
  final AuthController auth;
  const EditProfile({super.key, required this.auth});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _avatarImage;
  File? _headerImage;
  final formKey = GlobalKey<FormState>();
  late TextEditingController nameCtrl;
  late TextEditingController bioCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController usernameCtrl;
  final _picker = ImagePicker();
  UserModel? user;

  @override
  void initState() {
    super.initState();
    user = widget.auth.userData!;
    if (user != null) {
      nameCtrl = TextEditingController(text: user!.fullname);
      bioCtrl = TextEditingController(text: user!.bio);
      emailCtrl = TextEditingController(text: user!.email);
      usernameCtrl = TextEditingController(text: user!.username);
    }
  }

  Future<void> _pickImage(bool isAvatar) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 60,
    );

    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final fileSize = await file.length();

    if (fileSize > 500 * 1024) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Oversize image, please select another image')),
      );
      return;
    }

    setState(() {
      if (isAvatar) {
        _avatarImage = file;
      } else {
        _headerImage = file;
      }
    });
  }

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
                "Edit Profile",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 14),

              /// AVATAR
              GestureDetector(
                onTap: () => _pickImage(true),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  backgroundImage: _avatarImage != null
                      ? FileImage(_avatarImage!)
                      : user!.photo.isNotEmpty
                      ? user!.photo.toImageProvider()
                      : const AssetImage('assets/images/default-ava.png')
                            as ImageProvider,
                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Color(0xFF5A7863),
                      ),
                    ),
                  ),
                ),
              ),

              TextButton.icon(
                onPressed: () => _pickImage(false),
                icon: const Icon(Icons.image, color: Color(0xFF5A7863)),
                label: const Text(
                  "Change the header background",
                  style: TextStyle(color: Color(0xFF5A7863)),
                ),
              ),

              const SizedBox(height: 10),

              FieldEditProfile(
                controller: nameCtrl,
                label: "Fullname",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your fullname";
                  }
                  return null;
                },
              ),
              FieldEditProfile(
                controller: usernameCtrl,
                label: "Username",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your username";
                  }
                  return null;
                },
              ),
              FieldEditProfile(
                controller: emailCtrl,
                label: "Email",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your email";
                  }
                  if (!value.contains("@")) {
                    return "Enter the valid email";
                  }
                  return null;
                },
              ),
              FieldEditProfile(
                controller: bioCtrl,
                label: "Bio (Opsional)",
                maxLines: 3,
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 24),

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
                          await widget.auth.updateProfile(
                            username: usernameCtrl.text.trim(),
                            fullname: nameCtrl.text.trim(),
                            bio: bioCtrl.text.trim(),
                            email: emailCtrl.text.trim(),
                            photo: _avatarImage,
                            headerBanner: _headerImage,
                          );

                          if (!context.mounted) return;

                          Navigator.pop(context);

                          setState(() {
                            _avatarImage = null;
                            _headerImage = null;
                          });
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            context.read<AuthController>().loadUser(
                              force: true,
                            );
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated')),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                child: widget.auth.isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Apply Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
