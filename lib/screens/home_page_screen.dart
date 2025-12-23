import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  String? userID;
  String? userLevel;

  @override
  void initState() {
    super.initState();
    _checkLogin();
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
    print(userID);
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF73a664),
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
                    // Navigator.pushNamed(context, "/chatbot");
                  },
                  tooltip: "Notification",
                  icon: Icon(
                    Icons.notification_important,
                    color: Color(0xFF73a664),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/chatbot");
                  },
                  tooltip: "Chatbot AI",
                  icon: Icon(Icons.smart_toy, color: Color(0xFF73a664)),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/signIn");
                    authController.logout();
                  },
                  tooltip: "Your Account",
                  icon: Icon(Icons.person, color: Color(0xFF73a664)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/default-ava.png')
                                as ImageProvider,
                        // backgroundImage: (user.photo.toString().isNotEmpty)
                        //     ? authService.getImageProvider(user.photo)
                        //     : AssetImage('assets/images/default-profile.png')
                        //           as ImageProvider,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      drawer: Drawer(),
    );
  }
}
