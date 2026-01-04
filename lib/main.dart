import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/controllers/notification_controller.dart';
import 'package:uas_project/firebase_options.dart';
import 'package:uas_project/onboarding_page.dart';
import 'package:uas_project/screens/audio_relaxation/playlist_screen.dart';
import 'package:uas_project/screens/auth/auth_screen.dart';
import 'package:uas_project/screens/chatbot/chat_bot_ui.dart';
import 'package:uas_project/screens/community/community_screen.dart';
import 'package:uas_project/screens/community/create_post_screen.dart';
import 'package:uas_project/screens/counsultant/admin_approval_screen.dart';
import 'package:uas_project/screens/counsultant/consultant_list_screen.dart';
import 'package:uas_project/screens/counsultant/consultant_register_screen.dart';
import 'package:uas_project/screens/home_screen.dart';
import 'package:uas_project/screens/journal/create_journal.dart';
import 'package:uas_project/screens/journal/list_journal_screen.dart';
import 'package:uas_project/screens/mood_tracker/ask_mood.dart';
import 'package:uas_project/screens/mood_tracker/mood_tracker_screen.dart';
import 'package:uas_project/screens/notification_screen.dart';
import 'package:uas_project/screens/profile/profile_screen.dart';
import 'package:uas_project/screens/psychology_test/psychology_test_list.dart';
import 'package:uas_project/screens/users/user_list.dart';
import 'package:uas_project/screens/welcome_screen.dart';
import 'package:uas_project/services/mood_tracker_service.dart';
import 'package:uas_project/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),

        ChangeNotifierProvider(create: (_) => NotificationController()),
        ChangeNotifierProvider(create: (_) => MoodTrackerService()),
      ],
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
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/welcomeScreen': (context) => const WelcomeScreen(),
        '/signIn': (context) => const AuthScreen(isSignIn: true),
        '/signUp': (context) => const AuthScreen(isSignIn: false),
        '/homeScreen': (context) => const HomeScreen(),
        '/profileScreen': (context) => const ProfileScreen(),
        '/userList': (context) => const UserList(),
        '/notification': (context) => const NotificationScreen(),
        '/chatbot': (context) => const ChatPage(),
        '/moodTracker': (context) => const MoodTrackerScreen(),
        '/askMood': (context) => const AskMood(),
        '/psychologyTestList': (context) => const PsychologyTestList(),
        '/counseling': (context) => const ConsultantListScreen(),
        '/counsultantRegis': (context) => const ConsultantRegisterScreen(),
        '/requestList': (context) => const AdminApprovalScreen(),
        '/community': (context) => CommunityScreen(),
        '/createCommunity': (context) => CreatePostScreen(),
        '/audioRelaxation': (context) => AudioPlaylistScreen(),
        '/listJournal': (context) => ListJournalScreen(),        '/createJournal': (context) => CreateJournal(),
      },
    );
  }
}
