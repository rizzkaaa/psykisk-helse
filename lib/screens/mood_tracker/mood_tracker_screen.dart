import 'package:flutter/material.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:uas_project/controllers/auth_controller.dart';
import 'package:uas_project/screens/mood_tracker/countdown_timer.dart';
import 'package:uas_project/screens/mood_tracker/mood_logs_screen.dart';
import 'package:uas_project/services/mood_tracker_service.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  State<MoodTrackerScreen> createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  final MoodTrackerService _moodTrackerService = MoodTrackerService();
  bool? hasLoggedToday;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkMoodToday();
  }

  bool isAllowedTime() {
    final now = DateTime.now();
    return now.hour >= 20;
  }

  Future<void> _checkMoodToday() async {
    final auth = context.read<AuthController>();

    final result = await _moodTrackerService.hasMoodLogToday(
      auth.userData!.docId!,
    );

    print("hasil: $result");
    setState(() {
      hasLoggedToday = result;
      isLoading = false;
      print(hasLoggedToday);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    final allowed = isAllowedTime();
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4DD),
      appBar: AppBar(
        backgroundColor: Color(0xFF73a664),
        leading: SizedBox(),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        actions: [
          Container(
            decoration: inset.BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(2, 0),
                  inset: true,
                ),
                inset.BoxShadow(
                  color: Colors.black45.withOpacity(0.5),
                  blurRadius: 2,
                  offset: Offset(-2, 0),
                  inset: true,
                ),
              ],
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.reply, color: Color(0xFF73a664)),
                  onPressed: () => Navigator.pop(context),
                  tooltip: "Back",
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  decoration: inset.BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                    color: Color(0xFF73a664),
                    boxShadow: [
                      inset.BoxShadow(
                        color: Colors.black45.withOpacity(0.5),
                        blurRadius: 2,
                        offset: Offset(2, 0),
                        inset: false,
                      ),
                      inset.BoxShadow(
                        color: Colors.black45.withOpacity(0.5),
                        blurRadius: 2,
                        offset: Offset(-2, 0),
                        inset: false,
                      ),
                      inset.BoxShadow(
                        color: Colors.black45.withOpacity(0.5),
                        blurRadius: 2,
                        offset: Offset(0, -2),
                        inset: true,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Mood Tracker",
                        style: GoogleFonts.modernAntiqua(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF5A7863)),
                  )
                : hasLoggedToday == true
                ? Container(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      "You already track your mood today, see you tomorrow!",
                      style: GoogleFonts.modernAntiqua(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B8E7B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : allowed
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: inset.BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF5C8374),
                      boxShadow: [
                        inset.BoxShadow(
                          color: Colors.black45.withOpacity(0.5),
                          blurRadius: 2,
                          offset: Offset(2, 0),
                          inset: true,
                        ),
                        inset.BoxShadow(
                          color: Colors.black45.withOpacity(0.5),
                          blurRadius: 2,
                          offset: Offset(-2, 0),
                          inset: true,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, "/askMood"),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Mood Tracker",
                            style: GoogleFonts.bricolageGrotesque(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Lottie.asset(
                            "assets/animation/alert.json",
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  )
                : CountdownTimer(),
          ),
          auth.userData == null
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFF73a664)),
                )
              : Expanded(child: MoodLogsScreen(idUser: auth.userData!.docId!)),
        ],
      ),
    );
  }
}
