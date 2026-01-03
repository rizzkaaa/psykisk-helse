import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/models/users_model.dart';
import 'package:uas_project/screens/counsultant/counsultant_card.dart';

class ConsultantListScreen extends StatefulWidget {
  const ConsultantListScreen({super.key});

  @override
  State<ConsultantListScreen> createState() => _ConsultantListScreenState();
}

class _ConsultantListScreenState extends State<ConsultantListScreen> {
  final AuthController _authController = AuthController();
  late Future<List<UserModel>> _consultantData;

  @override
  void initState() {
    super.initState();
    _consultantData = _authController.fetchConsultant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5A7863),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: PatternPainter())),

                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 20, 32, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "LET'S TALK",
                              style: GoogleFonts.inknutAntiqua(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Find a consultant who's ready\n"
                              "to listen and support you.",
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Colors.white70,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        height: 110,
                        child: Lottie.asset(
                          'assets/animation/talk.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                decoration: const BoxDecoration(
                  color: Color(0xFF90AB8B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: FutureBuilder(
                  future: _consultantData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No consultants available',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      );
                    }

                    final counsultans = snapshot.data!;

                    return Column(
                      children: [
                        const Text(
                          'Choose the consultant here',
                          style: TextStyle(
                            color: Color(0xFFF5F5F5),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: counsultans.length,
                            itemBuilder: (context, index) {
                              return CounsultantCard(
                                counsultant: counsultans[index],
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= PATTERN PAINTER =================
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4A6353).withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final paintDark = Paint()
      ..color = const Color(0xFF3A5343).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    const shapeSize = 28.0;
    const spacing = 8.0;
    const totalSize = shapeSize + spacing;

    // Draw pattern grid
    for (double x = -shapeSize; x < size.width + shapeSize; x += totalSize) {
      for (double y = -shapeSize; y < size.height + shapeSize; y += totalSize) {
        final isEvenRow = ((y / totalSize).floor() % 2 == 0);
        final isEvenCol = ((x / totalSize).floor() % 2 == 0);

        // Alternate between circle and square
        if (isEvenRow == isEvenCol) {
          // Draw circle (darkened)
          canvas.drawCircle(
            Offset(x + shapeSize / 2, y + shapeSize / 2),
            shapeSize / 2,
            paintDark,
          );
        } else {
          // Draw square (lighter)
          canvas.drawRect(Rect.fromLTWH(x, y, shapeSize, shapeSize), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
