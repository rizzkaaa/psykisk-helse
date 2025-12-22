// import 'package:flutter/material.dart';
// import '../main.dart'; // Import shared widgets
// import '../models/role_model.dart'; // Import Role model and data

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   bool _agreedToTerms = false;
//   Role? _selectedRole;

//   @override
//   void initState() {
//     super.initState();
//     // Set default role selection
//     _selectedRole = availableRoles.first;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             buildHeader(context, title: 'Get Started'),
//             Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   buildTextField('Full Name', 'Enter Full Name'),
//                   const SizedBox(height: 20),
//                   buildTextField('Username', 'Enter Username'),
//                   const SizedBox(height: 20),
//                   buildTextField('Email', 'Enter Email'),
//                   const SizedBox(height: 20),
//                   buildTextField('Password', 'Enter Password', isPassword: true),
//                   const SizedBox(height: 20),

//                   // --- ROLE SELECTION ---
//                   const Text(
//                     'Select Role',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),
//                   ),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<Role>(
//                     decoration: InputDecoration(
//                       contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                     value: _selectedRole,
//                     hint: const Text('Choose your role'),
//                     isExpanded: true,
//                     items: availableRoles.map((Role role) {
//                       return DropdownMenuItem<Role>(
//                         value: role,
//                         child: Text(role.name),
//                       );
//                     }).toList(),
//                     onChanged: (Role? newValue) {
//                       setState(() {
//                         _selectedRole = newValue;
//                       });
//                     },
//                   ),
//                   const SizedBox(height: 20),
                 

//                   Row(
//                     children: [
//                       Checkbox(
//                         value: _agreedToTerms,
//                         onChanged: (bool? newValue) {
//                           setState(() {
//                             _agreedToTerms = newValue ?? false;
//                           });
//                         },
//                         activeColor: const Color(0xFF1976D2),
//                       ),
//                       const Text('I agree to the processing of '),
//                       GestureDetector(
//                         onTap: () {},
//                         child: const Text(
//                           'Personal data',
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
//                     onPressed: _agreedToTerms && _selectedRole != null ? () {/* Sign up logic */}: null,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF1976D2),
//                       foregroundColor: Colors.white,
//                       minimumSize: const Size(double.infinity, 50),
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                     ),
//                     child: const Text('Sign up', style: TextStyle(fontSize: 18)),
//                   ),
                 
                 
//                   const SizedBox(height: 30),
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Already have an account? "),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushReplacementNamed(context, '/login');
//                           },
//                           child: const Text(
//                             'Sign in',
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