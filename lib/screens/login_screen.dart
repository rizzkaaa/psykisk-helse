// import 'package:flutter/material.dart';
// import '../main.dart'; // Import shared widgets

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             buildHeader(context), 
//             Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Welcome back',
//                     style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF1976D2),
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   buildTextField('Email', 'kristin.watson@example.com'),
//                   const SizedBox(height: 20),
//                   buildTextField('Password', '******', isPassword: true),
//                   const SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Checkbox(
//                             value: true,
//                             onChanged: (bool? newValue) {},
//                             activeColor: const Color(0xFF1976D2),
//                           ),
//                           const Text('Remember me'),
//                         ],
//                       ),
//                       GestureDetector(
//                         onTap: () {},
//                         child: const Text(
//                           'Forgot password?',
//                           style: TextStyle(
//                             color: Color(0xFF1976D2),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 30),
//                   ElevatedButton(
//                     onPressed: () {/* Sign in logic */},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1976D2),
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     child: const Text('Sign in', style: TextStyle(fontSize: 18)),
//                   ),
                  
                 
//                   const SizedBox(height: 40),
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Don't have an account? "),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushReplacementNamed(context, '/register');
//                           },
//                           child: const Text(
//                             'Sign up',
//                             style: TextStyle(
//                               color: Color(0xFF1976D2),
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }