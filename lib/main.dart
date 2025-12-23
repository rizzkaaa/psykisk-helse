import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/screens/auth_screens/auth_screen.dart';
import 'package:uas_project/screens/chatbot_screens/chat_bot_ui.dart';
import 'package:uas_project/screens/home_page_screen.dart';
import 'package:uas_project/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/signIn': (context) => const AuthScreen(isSignIn: true),
        '/signUp': (context) => const AuthScreen(isSignIn: false),
        '/homePage': (context) => const HomePageScreen(),
        '/chatbot': (context) => const ChatPage(),
      },
    );
  }
}
