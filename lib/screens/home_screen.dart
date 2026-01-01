import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/post_model.dart';
import 'package:uas_project/screens/community/card_post.dart';
import 'package:uas_project/screens/psychology_test/psychology_test_list.dart';
import 'package:uas_project/services/community_service.dart';
import 'package:uas_project/widgets/tab_menu_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userID;
  String? userLevel;
  final CommunityService _communityService = CommunityService();
  late Stream<List<PostModel>> postsData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().loadUser();
    });
    _checkLogin();
    postsData = _communityService.getPostsStream();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('userId');
    final level = prefs.getString('userLevel');

    if (uid == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, "/");
      });
    }

    setState(() {
      userID = uid;
      userLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/chatbot");
                  },
                  tooltip: "Chatbot AI",
                  icon: Icon(Icons.support_agent, color: Color(0xFF5C8374)),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/profilePage");
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
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF5A7863)))
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
                      Lottie.asset(
                        "assets/animation/happy-emoji.json",
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
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
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PsychologyTestList()));
                          },
                          icon: Icons.psychology,
                          title: "Psychology",
                          titleOpsional: "Test",
                        ),
                        const SizedBox(width: 20),
                        TabMenuHome(
                          onPressed: () {},
                          icon: Icons.menu_book,
                          title: "Education",
                          titleOpsional: "Content",
                        ),
                        const SizedBox(width: 20),
                        TabMenuHome(
                          onPressed: () {},
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

      drawer: Drawer(),
    );
  }
}
