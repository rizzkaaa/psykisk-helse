import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/screens/profile_screen/edit_password.dart';
import 'package:uas_project/screens/profile_screen/edit_profile.dart';
import 'package:uas_project/screens/profile_screen/profile_info_card.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/widgets/confirm_dialog.dart';
import 'package:uas_project/widgets/tab_menu_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void openEditProfile(AuthController auth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFEBF4DD),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return EditProfile(auth: auth);
      },
    );
  }

  void openEditPassword(AuthController auth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFEBF4DD),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return EditPassword(auth: auth);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final user = auth.userData;

    return Scaffold(
      backgroundColor: Color(0xFFEBF4DD),
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5A7863)),
            )
          : Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: user.headerBanner.isNotEmpty
                              ? user.headerBanner.toImageProvider()
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
                              onPressed: () => openEditProfile(auth),
                              tooltip: "Edit",
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.logout,
                                color: Color(0xFF5A7863),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return ConfirmDialog(
                                      title: "Are you sure want to sign out?",
                                      onConfirm: () async {
                                        Navigator.pushNamed(context, "/signIn");
                                        await auth.logout();
                                      },
                                    );
                                  },
                                );
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
                                ? user.photo.toImageProvider()
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
                Container(
                  height: 60,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    border: Border.symmetric(
                      horizontal: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      TabMenuProfile(
                        onTap: () {},
                        icon: Icons.person,
                        label: "Data",
                      ),
                      TabMenuProfile(
                        onTap: () {},
                        icon: Icons.favorite,
                        label: "Favorite",
                      ),
                      TabMenuProfile(
                        onTap: () {},
                        icon: Icons.bookmark,
                        label: "Bookmark",
                      ),
                      TabMenuProfile(
                        onTap: () {},
                        icon: Icons.chat_bubble,
                        label: "Post",
                      ),
                      TabMenuProfile(
                        onTap: () {},
                        icon: Icons.book,
                        label: "Journal",
                      ),
                    ],
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
                        onPressed: () => openEditPassword(auth),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
    );
  }
}
