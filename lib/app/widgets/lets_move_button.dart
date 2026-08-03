import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class LetsMoveButton extends StatefulWidget {
  const LetsMoveButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  State<LetsMoveButton> createState() => _LetsMoveButtonState();
}

class _LetsMoveButtonState extends State<LetsMoveButton> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) {
      return;
    }

    setState(() {
      _isPressed = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Start a Movement Break',
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: Container(
          width: 224,
          height: 224,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x8025E987),
                blurRadius: 42,
                spreadRadius: 7,
              ),
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: Ink(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.brightGreen, AppColors.primaryGreen],
                ),
                border: Border.all(color: AppColors.textPrimary, width: 4),
              ),
              child: InkWell(
                customBorder: const CircleBorder(),
                splashColor: Colors.white24,
                highlightColor: Colors.white10,
                onTap: widget.onPressed,
                onHighlightChanged: _setPressed,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.directions_walk_rounded,
                        size: 66,
                        color: AppColors.backgroundDark,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "LET'S MOVE!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.backgroundDark,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
