import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/widgets/tab_menu_home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String? userID;
  // String? userLevel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthController>().loadUser();
    });
    // _checkLogin();
  }

  // Future<void> _checkLogin() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final uid = prefs.getString('userId');
  //   final level = prefs.getString('userLevel');

  //   if (uid == null) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Navigator.pushNamed(context, "/");
  //     });
  //   }

  //   setState(() {
  //     userID = uid;
  //     userLevel = level;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final authController = context.watch<AuthController>();

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
                    // authController.logout();
                  },
                  tooltip: "Your Account",
                  icon: Icon(Icons.person, color: Color(0xFF5C8374)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFF5C8374),
            padding: const EdgeInsets.only(left: 40, right: 40, bottom: 50),
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
                            AssetImage('assets/images/default-ava.png')
                                as ImageProvider,
                        // backgroundImage: (user.photo.toString().isNotEmpty)
                        //     ? authService.getImageProvider(user.photo)
                        //     : AssetImage('assets/images/default-ava.png')
                        //           as ImageProvider,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Nella Aprilia",
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
                    onPressed: () {},
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
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                    onPressed: () {},
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
                    onPressed: () => Navigator.pushNamed(context, "/community"),
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
                    onPressed: () {},
                    icon: Icons.book,
                    title: "Journal",
                  ),
                ],
              ),
            ),
          ),
          Text("halo"),
        ],
      ),

      drawer: Drawer(),
    );
  }
}
