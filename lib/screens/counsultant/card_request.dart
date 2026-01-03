import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/services/counsultant_service.dart';
import 'package:uas_project/models/counsultant_model.dart';

class CardRequest extends StatefulWidget {
  final CounsultantModel request;
  final VoidCallback reloadData;
  const CardRequest({
    super.key,
    required this.request,
    required this.reloadData,
  });

  @override
  State<CardRequest> createState() => _CardRequestState();
}

class _CardRequestState extends State<CardRequest> {
  final CounsultantService _counsultantService = CounsultantService();
  final AuthController _authController = AuthController();
  late Future<UserModel?> _userData;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _userData = _authController.fetchUserByID(widget.request.idUser);
  }

  void action(String status) async {
    isLoading = true;
    try {
      await _counsultantService.changeStatus(
        idRequest: widget.request.docId!,
        idUser: widget.request.idUser,
        status: status,
      );
      isLoading = false;
      widget.reloadData();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Success")));
      }
    } catch (e) {
      isLoading = false;
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed change status: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "There's no user",
              style: TextStyle(color: Colors.white70),
            ),
          );
        } else {
          final user = snapshot.data!;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEFE0),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: CircleAvatar(
                        backgroundImage: (user.photo.toString().isNotEmpty)
                            ? user.photo.toImageProvider()
                            : AssetImage('assets/images/default-ava.png')
                                  as ImageProvider,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullname.isNotEmpty
                              ? user.fullname
                              : "@${user.username}",
                          style: GoogleFonts.bricolageGrotesque(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Specialize: ${widget.request.spesialis}",
                          style: GoogleFonts.bricolageGrotesque(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  children: [
                    _doc("Professional Psychologist Degree", "ppd"),
                    _doc(
                      "Psychologist Registration Certificate (STRP)",
                      "strp",
                    ),
                    _doc("Psychologist Practice License (SIPP)", "sipp"),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    _action(
                      isLoading: isLoading,
                      label: "Approve",
                      color: Colors.green,
                      enabled: widget.request.status != 'approved',
                      onTap: () => action('approved'),
                    ),
                    const SizedBox(width: 12),
                    _action(
                      isLoading: isLoading,
                      label: "Reject",
                      color: Colors.red,
                      enabled: widget.request.status != 'rejected',
                      onTap: () => action('rejected'),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Text(
                  "Status: ${widget.request.status.toUpperCase()}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: widget.request.status == 'approved'
                        ? Colors.green
                        : widget.request.status == 'rejected'
                        ? Colors.red
                        : Colors.orange,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _doc(String label, String type) {
    return TextButton.icon(
      onPressed: () async {
        try {
          final doc = await _counsultantService.getDocument(
            requestId: widget.request.docId!,
            type: type,
          );

          print(doc);

          final file = await _counsultantService.saveBase64Pdf(
            base64: doc.fileBase64,
            fileName: '${type}_${DateTime.now().millisecondsSinceEpoch}',
          );

          await OpenFilex.open(file.path);
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
      icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
      label: Text(
        label,
        style: GoogleFonts.bricolageGrotesque(color: Color(0xFF5A7863)),
      ),
    );
  }

  Widget _action({
    required String label,
    required Color color,
    required bool enabled,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : ElevatedButton(
              onPressed: enabled ? onTap : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: enabled ? color : Colors.grey,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                label,
                style: GoogleFonts.bricolageGrotesque(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
