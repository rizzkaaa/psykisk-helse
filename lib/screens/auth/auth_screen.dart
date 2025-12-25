import 'package:flutter/material.dart';
import 'package:uas_project/screens/auth/sign_in_screen.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart' as inset;
import 'package:uas_project/screens/auth/sign_up_screen.dart';

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
      body: SingleChildScrollView(
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
                bottom: _isSignIn ? 0 : 220,
                top: _isSignIn ? 350 : 0,
                curve: Curves.easeInOut,
                right: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 5,
                  ),
                  decoration: inset.BoxDecoration(
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
                      inset.BoxShadow(
                        color: Colors.black38.withOpacity(0.3),
                        blurRadius: 2,
                        offset: _isSignIn ? Offset(0, 2) : Offset(0, -2),
                        inset: true,
                      ),
                    ],
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
    );
  }
}
