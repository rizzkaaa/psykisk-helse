import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/screens/home_page_screen.dart';
import 'package:uas_project/screens/login_screen.dart';
import 'package:uas_project/screens/register_screen.dart';
import 'package:uas_project/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
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
      routes: {
        '/': (context) => const WelcomeScreen(),
        // '/login': (context) => const LoginScreen(),
        // '/register': (context) => const RegisterScreen(),
      },
    );
  }
}


// Helper function to build the header background
// Widget buildHeader(BuildContext context, {String? title}) {
//   return Container(
//     height: 250,
//     width: double.infinity,
//     decoration: const BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
//         begin: Alignment.topRight,
//         end: Alignment.bottomLeft,
//       ),
//     ),
//     child: Stack(
//       children: [
//         // Decorative shapes
//         Positioned(
//           top: -50,
//           left: 100,
//           child: buildCircle(150, const Color(0xFF42A5F5).withOpacity(0.5)),
//         ),
//         Positioned(
//           bottom: -50,
//           right: 0,
//           child: buildCircle(250, const Color(0xFF1976D2).withOpacity(0.6)),
//         ),

//         // Back button and optional title
//         Padding(
//           padding: const EdgeInsets.only(top: 40.0, left: 10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (Navigator.of(context).canPop())
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               if (title != null) ...[
//                 const SizedBox(height: 50),
//                 Center(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // Helper function for custom TextFields
// Widget buildTextField(String label, String hint, {bool isPassword = false}) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//           color: Colors.grey,
//         ),
//       ),
//       const SizedBox(height: 8),
//       TextField(
//         obscureText: isPassword,
//         decoration: InputDecoration(
//           hintText: hint,
//           contentPadding: const EdgeInsets.symmetric(
//             vertical: 15,
//             horizontal: 15,
//           ),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       ),
//     ],
//   );
// }

// // Helper function for social icons (using placeholder)
// Widget buildSocialIcon(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//     child: Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Icon(
//         Icons.people,
//         color: Theme.of(context).colorScheme.secondary,
//       ), // Placeholder icon
//     ),
//   );
// }
