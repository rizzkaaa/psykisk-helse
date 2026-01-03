import 'package:flutter/material.dart';
import 'package:uas_project/extensions/firestore_extension.dart';
import 'package:uas_project/models/counsultant_model.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/services/counsultant_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CounsultantCard extends StatefulWidget {
  final UserModel counsultant;

  const CounsultantCard({super.key, required this.counsultant});

  @override
  State<CounsultantCard> createState() => _CounsultantCardState();
}

class _CounsultantCardState extends State<CounsultantCard> {
  bool _pressed = false;
  final CounsultantService _counsultantService = CounsultantService();
  late Future<CounsultantModel> _consultantData;

  @override
  void initState() {
    super.initState();
    _consultantData = _counsultantService.getConsultantByIDUser(
      idUser: widget.counsultant.docId!,
    );
  }

  Future<void> _launchWhatsApp(String whatsappNo) async {
    final phone = whatsappNo
        .replaceAll(RegExp(r'[^0-9]'), '')
        .replaceFirst(RegExp(r'^0'), '62');

    final message = Uri.encodeComponent('Hello Doctor, I need consultation');

    final uri = Uri.parse('https://wa.me/$phone?text=$message');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _consultantData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error Fetch Data: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text("No data", style: TextStyle(color: Colors.white70)),
          );
        } else {
          final c = snapshot.data!;

          return AnimatedScale(
            scale: _pressed ? 0.97 : 1,
            duration: const Duration(milliseconds: 120),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEFE0),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _pressed
                        ? const Color(0xFF5A7863).withOpacity(0.35)
                        : Colors.black.withOpacity(0.08),
                    blurRadius: _pressed ? 18 : 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image(
                          image: widget.counsultant.photo.isNotEmpty
                              ? widget.counsultant.photo.toImageProvider()
                              : const AssetImage(
                                  'assets/images/default-ava.png',
                                ),
                                width: 100,
                                height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.counsultant.fullname.isNotEmpty
                              ? widget.counsultant.fullname
                              : widget.counsultant.username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          c.spesialis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF696A63),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              c.availableTime,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTapDown: (_) => setState(() => _pressed = true),
                          onTapUp: (_) => setState(() => _pressed = false),
                          onTapCancel: () => setState(() => _pressed = false),
                          onTap: () => _launchWhatsApp(c.whatsappNo),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              FaIcon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                                size: 18,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Start consulting',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
