import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/firebase_options.dart';
import 'package:uas_project/onboarding_page.dart';
import 'package:uas_project/screens/audio_relaxation/playlist_screen.dart';
import 'package:uas_project/screens/auth/auth_screen.dart';
import 'package:uas_project/screens/chatbot/chat_bot_ui.dart';
import 'package:uas_project/screens/community/community_screen.dart';
import 'package:uas_project/screens/community/create_post_screen.dart';
import 'package:uas_project/screens/home_page.dart';
import 'package:uas_project/screens/notification_screen.dart';
import 'package:uas_project/screens/profile_screen/profile_screen.dart';
import 'package:uas_project/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthController())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Psykisk Helse',
      initialRoute: "/",
      routes: {
        // '/': (context) => const SplashScreen(),
        '/': (context) => const WelcomeScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/welcomeScreen': (context) => const WelcomeScreen(),
        '/signIn': (context) => const AuthScreen(isSignIn: true),
        '/signUp': (context) => const AuthScreen(isSignIn: false),
        '/homePage': (context) => const HomePage(),
        '/profilePage': (context) => const ProfileScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/chatbot': (context) => const ChatPage(),
        '/community': (context) => CommunityScreen(),
        '/createCommunity': (context) => CreatePostScreen(),
        '/audioRelaxation': (context) => AudioPlaylistScreen(),
      },
    );
  }
}
