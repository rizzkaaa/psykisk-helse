import 'dart:async';
import 'package:flutter/material.dart';
import 'result_screen.dart';

class WaitingScreen extends StatefulWidget {
  final int score;
  const WaitingScreen({super.key, required this.score});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  int _seconds = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds > 0)
        setState(() => _seconds--);
      else {
        t.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ResultScreen(score: widget.score)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Color(0xFF5C8374),),
            const SizedBox(height: 30),
            const Text("Analyzing your answers...."),
            Text(
              "${(_seconds ~/ 60)}:${(_seconds % 60).toString().padLeft(2, '0')}",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5C8374),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
