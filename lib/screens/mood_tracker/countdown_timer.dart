import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration remaining;
  late Timer timer;
  Duration timeUntilAllowed() {
    final now = DateTime.now();
    final allowedTime = DateTime(now.year, now.month, now.day, 20, 0);

    return allowedTime.difference(now);
  }

  @override
  void initState() {
    super.initState();
    remaining = timeUntilAllowed();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        remaining = timeUntilAllowed();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    return Container(
      color:  Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            "$hours:$minutes:$seconds",
            style: GoogleFonts.modernAntiqua(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B8E7B),
            ),
          ),
          Text(
            "Mood tracker feature opens at 08:00 PM.",
            style: GoogleFonts.bricolageGrotesque(color: Color(0xFF6B8E7B),),
          ),
        ],
      ),
    );

    // Column(
    //   mainAxisSize: MainAxisSize.min,
    //   children: [

    //     Text("Akses dibuka pukul 20.00", style: TextStyle(fontSize: 18)),
    //     const SizedBox(height: 10),
    //     Text(
    //       "$hours:$minutes:$seconds",
    //       style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    //     ),
    //   ],
    // );
  }
}
