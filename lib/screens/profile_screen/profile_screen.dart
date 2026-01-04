import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/screens/profile_screen/bookmark_journal_content.dart';
import 'package:uas_project/screens/profile_screen/data_content.dart';
import 'package:uas_project/screens/profile_screen/edit_password.dart';
import 'package:uas_project/screens/profile_screen/edit_profile.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/screens/profile_screen/favorite_post_content.dart';
import 'package:uas_project/widgets/confirm_dialog.dart';
import 'package:uas_project/widgets/tab_menu_profile.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? selectUser;
  const ProfileScreen({super.key, this.selectUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

enum ProfileTab { data, favorite, bookmark, post, journal }

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileTab activeTab;

  @override
  void initState() {
    super.initState();
    activeTab = widget.selectUser == null ? ProfileTab.data : ProfileTab.post;
  }

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
    final currentUser = auth.userData;
    final user = widget.selectUser ?? currentUser;

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
                              onPressed: () =>
                                  Navigator.pushNamed(context, "/homeScreen"),
                              tooltip: "Back",
                            ),
                            if (widget.selectUser == null)
                              Row(
                                children: [
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
                                            title:
                                                "Are you sure want to sign out?",
                                            onConfirm: () async {
                                              Navigator.pushNamed(
                                                context,
                                                "/signIn",
                                              );
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
                  child: widget.selectUser == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TabMenuProfile(
                              isActive: activeTab == ProfileTab.data,
                              onTap: () {
                                setState(() {
                                  activeTab = ProfileTab.data;
                                });
                              },
                              icon: Icons.person,
                              label: "Data",
                            ),

                            TabMenuProfile(
                              isActive: activeTab == ProfileTab.favorite,
                              onTap: () {
                                setState(() {
                                  activeTab = ProfileTab.favorite;
                                });
                              },
                              icon: Icons.favorite,
                              label: "Favorite",
                            ),

                            TabMenuProfile(
                              isActive: activeTab == ProfileTab.bookmark,
                              onTap: () {
                                setState(() {
                                  activeTab = ProfileTab.bookmark;
                                });
                              },
                              icon: Icons.bookmark,
                              label: "Bookmark",
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TabMenuProfile(
                              isActive: activeTab == ProfileTab.post,
                              onTap: () {
                                setState(() {
                                  activeTab = ProfileTab.post;
                                });
                              },
                              icon: Icons.chat_bubble,
                              label: "Post",
                            ),

                            TabMenuProfile(
                              isActive: activeTab == ProfileTab.journal,
                              onTap: () {
                                setState(() {
                                  activeTab = ProfileTab.journal;
                                });
                              },
                              icon: Icons.book,
                              label: "Journal",
                            ),
                          ],
                        ),
                ),
                Expanded(child: _buildContent(user, auth)),

                const SizedBox(height: 30),
              ],
            ),
    );
  }

  Widget _buildContent(UserModel user, AuthController auth) {
    switch (activeTab) {
      case ProfileTab.data:
        return DataContent(user: user, onPressed: () => openEditPassword(auth));

      case ProfileTab.favorite:
        return FavoritePostContent(idUser: user.docId!, isFavorite: true);

      case ProfileTab.bookmark:
        return BookmarkJournalContent(isBookmarked: true, idUser: user.docId!);

      case ProfileTab.post:
        return FavoritePostContent(idUser: user.docId!, isFavorite: false);

      case ProfileTab.journal:
        return BookmarkJournalContent(isBookmarked: false, idUser: user.docId!);
    }
  }
}
