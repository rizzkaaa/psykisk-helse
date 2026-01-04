import 'package:flutter/material.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/screens/profile/profile_info_card.dart';

class DataContent extends StatelessWidget {
  final UserModel user;
  final VoidCallback onPressed;
  const DataContent({super.key, required this.user, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 24),

          ProfileInfoCard(
            icon: Icons.person,
            title: "Username",
            value: user.username,
            color: const Color(0xFFE3F2FD),
          ),
          ProfileInfoCard(
            icon: Icons.email,
            title: "Email",
            value: user.email,
            color: const Color(0xFFF3E5F5),
          ),
          ProfileInfoCard(
            icon: Icons.verified,
            title: "Your Role",
            value: user.role,
            color: const Color(0xFFFFF5DB),
          ),
          ProfileInfoCard(
            icon: Icons.key,
            title: "Your Password",
            value: "●●●●●●●●●●",
            color: const Color(0xFFE8F5E9),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
