import 'package:flutter/material.dart';
import 'package:uas_project/screens/auth_screens/sign_in_screen.dart';
import 'package:uas_project/screens/auth_screens/sign_up_screen.dart';

class AuthScreen extends StatefulWidget {
  final bool isSignIn;
  const AuthScreen({super.key, required this.isSignIn});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignIn = true;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _isSignIn = widget.isSignIn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFEF0E5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedRotation(
                    turns: _isSignIn ? 0 : 0.5,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Image.asset(
                      'assets/images/bg-welcome.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 600),
                  bottom: _isSignIn ? 0 : 180,
                  top: _isSignIn ? 320 : 0,
                  curve: Curves.easeInOut,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: _isSignIn
                          ? BorderRadius.only(
                              topLeft: Radius.circular(70),
                              topRight: Radius.circular(70),
                            )
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(70),
                              bottomRight: Radius.circular(70),
                            ),
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: _opacity,
                      child: _isSignIn
                          ? SignInScreen(
                              onPressed: () async {
                                setState(() => _opacity = 0);

                                await Future.delayed(
                                  const Duration(milliseconds: 300),
                                );
                                setState(() {
                                  _isSignIn = false;
                                  _opacity = 1;
                                });
                              },
                            )
                          : SignUpScreen(
                              onPressed: () async {
                                setState(() => _opacity = 0);

                                await Future.delayed(
                                  const Duration(milliseconds: 300),
                                );
                                setState(() {
                                  _isSignIn = true;
                                  _opacity = 1;
                                });
                              },
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
