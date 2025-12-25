import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/widgets/field_edit_profile.dart';
import 'package:uas_project/widgets/profile_info_card.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> userProfile;
  final AuthController _authController = AuthController();
  File? _avatarImage;
  File? _headerImage;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    userProfile = _authController.getProfile();
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

  void openEditProfile(UserModel user) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: user.fullname);
    final bioCtrl = TextEditingController(text: user.bio);
    final emailCtrl = TextEditingController(text: user.email);
    final usernameCtrl = TextEditingController(text: user.username);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFEBF4DD),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
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
                          : user.photo.isNotEmpty
                          ? _authController.getImageProvider(user.photo)
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
                    onPressed: _authController.isLoading
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;

                            try {
                              await _authController.updateProfile(
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
                                userProfile = _authController.getProfile();
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profile updated'),
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                    child: _authController.isLoading
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
      },
    );
  }

  void openEditPassword(UserModel user) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController oldPasswordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFEBF4DD),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
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
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 6) {
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
                    onPressed: _authController.isLoading
                        ? null
                        : () async {
                            if (!formKey.currentState!.validate()) return;
                            try {
                              await _authController.updatePassword(
                                oldPasswordController.text.trim(),
                                newPasswordController.text.trim(),
                              );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Password updated'),
                                ),
                              );
                            } catch (e) {
                              print(e);
                              // Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                    child: _authController.isLoading
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBF4DD),
      body: FutureBuilder(
        future: userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Tidak ada data"));
          } else {
            final user = snapshot.data!;

            return Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: user.headerBanner.isNotEmpty
                              ? _authController.getImageProvider(
                                  user.headerBanner,
                                )
                              : const AssetImage('assets/images/scenery.jpg')
                                    as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.25),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 50,
                      right: 20,
                      child: Container(
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
                          color: Color(0xFFEBF4DD),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.reply,
                                color: Color(0xFF5A7863),
                              ),
                              onPressed: () => Navigator.pop(context),
                              tooltip: "Back",
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Color(0xFF5A7863),
                              ),
                              onPressed: () => openEditProfile(user),
                              tooltip: "Edit",
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.logout,
                                color: Color(0xFF5A7863),
                              ),
                              onPressed: () async {
                                Navigator.pushNamed(context, "/signIn");
                                await _authController.logout();
                              },
                              tooltip: "Sign Out",
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -45,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 48,
                            backgroundImage: user.photo.isNotEmpty
                                ? _authController.getImageProvider(user.photo)
                                : const AssetImage(
                                        'assets/images/default-ava.png',
                                      )
                                      as ImageProvider,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                Text(
                  user.fullname.isNotEmpty ? user.fullname : user.username,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    user.bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      ProfileInfoCard(
                        icon: Icons.person,
                        title: "Username",
                        value: user.username,
                        color: const Color(0xFFE3F2FD),
                      ),
                      ProfileInfoCard(
                        icon: Icons.email,
                        title: "Email",
                        value: user.email,
                        color: const Color(0xFFF3E5F5),
                      ),
                      ProfileInfoCard(
                        icon: Icons.verified,
                        title: "Your Role",
                        value: user.role,
                        color: const Color(0xFFFFF5DB),
                      ),
                      ProfileInfoCard(
                        icon: Icons.key,
                        title: "Your Password",
                        value: "●●●●●●●●●●",
                        color: const Color(0xFFE8F5E9),
                        onPressed: () => openEditPassword(user),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            );
          }
        },
      ),
    );
  }
}
