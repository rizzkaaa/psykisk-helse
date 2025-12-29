import 'package:flutter/material.dart';

class UnstyleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget content;
  
  const UnstyleButton({
    super.key,
    required this.onPressed,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        overlayColor: Colors.transparent,
      ),
      child: content,
    );
  }
}
