import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;
  final Color? borderColor;

  const SocialLoginButton({
    super.key,
    required this.text,
    required this.iconPath,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: borderColor != null
                ? Border.all(color: borderColor!)
                : null,
          ),
          child: Row(
            children: [
              Image.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 24),
            ],
          ),
        ),
      ),
    );
  }
}


