import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/controllers/notification_controller.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/post_model.dart';
import 'package:uas_project/screens/community/card_post.dart';
import 'package:uas_project/services/community_service.dart';
import 'package:uas_project/services/mood_tracker_service.dart';
import 'package:uas_project/widgets/tab_menu_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userID;
  String? userLevel;
  bool _notifSent = false;
  final NotificationController _notificationController =
      NotificationController();
  final CommunityService _communityService = CommunityService();
  late Stream<List<PostModel>> postsData;

  @override
  void initState() {
    super.initState();
    _checkLogin();
    postsData = _communityService.getPostsStream();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userId');
    final level = prefs.getString('userLevel');

    if (uid == null) {
      if (!mounted) return;
      Navigator.pushNamed(context, "/");
      return;
    }

    setState(() {
      userID = uid;
      userLevel = level;
    });

    await context.read<MoodTrackerService>().loadMood(idUser: uid);
    await context.read<AuthController>().loadUser();

    final mood = context.read<MoodTrackerService>();
    final auth = context.read<AuthController>();

    if (auth.userData == null) return;

    if (mood.moodDataToday == null && isAvailable() && !_notifSent) {
      _notifSent = true;
      print("send");
      await sendNotif(auth.userData!.docId!);
    }
  }

  bool isAvailable() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 20); 
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59); 

    return now.isAfter(start) && now.isBefore(end);
  }

  Future<void> sendNotif(String userID) async {
    try {
      await _notificationController.sendNotif(userID, "reminder");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mood = context.watch<MoodTrackerService>();
    final auth = context.watch<AuthController>();
    final user = auth.userData;

    return Scaffold(
      backgroundColor: const Color(0xFFEBF4DD),
      appBar: AppBar(
        backgroundColor: Color(0xFF5C8374),
        iconTheme: const IconThemeData(color: Colors.white),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        actions: [
          Container(
            decoration: inset.BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
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
            ),
            child: Row(
              children: [
                StreamBuilder<int>(
                  stream: _notificationController.countUnRead,
                  builder: (context, snapshot) {
                    final unreadCount = snapshot.data ?? 0;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "/notification");
                          },
                          tooltip: "Notification",
                          icon: Icon(
                            Icons.notification_important,
                            color: Color(0xFF5C8374),
                          ),
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: 3,
                            right: 3,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Color(0xFF5C8374),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$unreadCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/chatbot");
                  },
                  tooltip: "Chatbot AI",
                  icon: Icon(Icons.support_agent, color: Color(0xFF5C8374)),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/profileScreen");
                  },
                  tooltip: "Your Account",
                  icon: Icon(Icons.person, color: Color(0xFF5C8374)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5A7863)),
            )
          : Column(
              children: [
                Container(
                  color: Color(0xFF5C8374),
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    bottom: 50,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: CircleAvatar(
                              backgroundImage:
                                  (user.photo.toString().isNotEmpty)
                                  ? user.photo.toImageProvider()
                                  : AssetImage('assets/images/default-ava.png')
                                        as ImageProvider,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            user.username,
                            style: GoogleFonts.modernAntiqua(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      mood.moodDataToday == null
                          ? Lottie.asset(
                              "assets/animation/confused-emoji.json",
                              width: 170,
                              height: 170,
                              fit: BoxFit.contain,
                            )
                          : Lottie.asset(
                              "assets/animation/${mood.moodDataToday!.indicatorLottie}",
                              width: 170,
                              height: 170,
                              fit: BoxFit.contain,
                            ),
                      Text(
                        mood.moodDataToday == null
                            ? "There's no mood data for today yet. You can track your mood at 08:00 PM. Stay tuned!"
                            : mood.moodData[mood
                                  .moodDataToday!
                                  .indicatorScore]["text"]!,
                        style: GoogleFonts.bricolageGrotesque(
                          color: Color(0xFFEBF4DD),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: inset.BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
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
                        ),
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/moodTracker"),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            backgroundColor: Colors.transparent,
                          ),
                          child: Text(
                            "Mood Tracker",
                            style: GoogleFonts.bricolageGrotesque(
                              color: Color(0xFF5C8374),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -30),
                  child: Container(
                    height: 135,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    decoration: inset.BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
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
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        TabMenuHome(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            "/psychologyTestList",
                          ),
                          icon: Icons.psychology,
                          title: "Psychology",
                          titleOpsional: "Test",
                        ),
                        const SizedBox(width: 20),
                        TabMenuHome(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/counseling"),
                          icon: Icons.forum,
                          title: "Counseling",
                        ),
                        const SizedBox(width: 20),
                        TabMenuHome(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/community"),
                          icon: Icons.groups,
                          title: "Community",
                        ),
                        const SizedBox(width: 20),
                        TabMenuHome(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/audioRelaxation"),
                          icon: Icons.self_improvement,
                          title: "Relaxation",
                          titleOpsional: "Audio",
                        ),
                        const SizedBox(width: 20),
                        TabMenuHome(
                          onPressed: () =>
                              Navigator.pushNamed(context, "/listJournal"),
                          icon: Icons.book,
                          title: "Journal",
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: postsData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "There's no post",
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      } else {
                        final posts = snapshot.data!;

                        return ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            return CardPost(post: post);
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

      drawer: user == null
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF5A7863)),
            )
          : Drawer(
              backgroundColor: const Color(0xFF6B8E7B),
              child: Column(
                children: [
                  SafeArea(
                    child: Lottie.asset(
                      "assets/animation/love.json",
                      width: 170,
                      height: 170,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      decoration: inset.BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                        boxShadow: [
                          inset.BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 4,
                            offset: Offset(1, 1),
                            inset: true,
                          ),
                          inset.BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 4,
                            offset: Offset(-1, 1),
                            inset: true,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.person,
                              color: const Color(0xFF6B8E7B),
                              size: 30,
                            ),
                            title: Text(
                              "My Account",
                              style: GoogleFonts.modernAntiqua(
                                color: const Color(0xFF6B8E7B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, "/profileScreen"),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.notifications,
                              color: const Color(0xFF6B8E7B),
                              size: 30,
                            ),
                            title: Text(
                              "Notification",
                              style: GoogleFonts.modernAntiqua(
                                color: const Color(0xFF6B8E7B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, "/notification"),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.notifications,
                              color: const Color(0xFF6B8E7B),
                              size: 30,
                            ),
                            title: Text(
                              "Your AI Friend",
                              style: GoogleFonts.modernAntiqua(
                                color: const Color(0xFF6B8E7B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () =>
                                Navigator.pushNamed(context, "/chatbot"),
                          ),
                          if (user.role == 'admin')
                            Column(
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.group,
                                    color: const Color(0xFF6B8E7B),
                                    size: 30,
                                  ),
                                  title: Text(
                                    "User List",
                                    style: GoogleFonts.modernAntiqua(
                                      color: const Color(0xFF6B8E7B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () =>
                                      Navigator.pushNamed(context, "/userList"),
                                ),

                                ListTile(
                                  leading: Icon(
                                    Icons.assignment_ind,
                                    color: const Color(0xFF6B8E7B),
                                    size: 30,
                                  ),
                                  title: Text(
                                    "Counsultant Registration Request",
                                    style: GoogleFonts.modernAntiqua(
                                      color: const Color(0xFF6B8E7B),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    "/requestList",
                                  ),
                                ),
                              ],
                            ),
                          if (user.role == 'user')
                            ListTile(
                              leading: Icon(
                                Icons.assignment_ind,
                                color: const Color(0xFF6B8E7B),
                                size: 30,
                              ),
                              title: Text(
                                "Apply As Counsultant",
                                style: GoogleFonts.modernAntiqua(
                                  color: const Color(0xFF6B8E7B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                "/counsultantRegis",
                              ),
                            ),
                          // ListTile(
                          //   leading: Icon(
                          //     Icons.delete,
                          //     color: const Color(0xFF6B8E7B),
                          //     size: 30,
                          //   ),
                          //   title: Text(
                          //     "Delete Account",
                          //     style: GoogleFonts.modernAntiqua(
                          //       color: const Color(0xFF6B8E7B),
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          //   onTap: () => Navigator.pushNamed(context, "/profileScreen"),
                          // ),
                          // ListTile(
                          //   leading: Icon(
                          //     Icons.help_outline_sharp,
                          //     color: const Color(0xFF6B8E7B),
                          //     size: 30,
                          //   ),
                          //   title: Text(
                          //     "Contact Us",
                          //     style: GoogleFonts.modernAntiqua(
                          //       color: const Color(0xFF6B8E7B),
                          //       fontWeight: FontWeight.bold,
                          //     ),
                          //   ),
                          //   onTap: () => Navigator.pushNamed(context, "/profileScreen"),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
