import 'package:flutter/material.dart';
import 'package:coffe_app/core/constants/app_spacing.dart';
import 'package:coffe_app/core/constants/app_radius.dart';
import 'package:coffe_app/core/constants/app_typography.dart';

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
      borderRadius: AppRadius.border(AppRadius.size18),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.border(AppRadius.size18),
        child: Container(
          height: 56,
          padding: AppSpacing.paddingH16,
          decoration: BoxDecoration(
            borderRadius: AppRadius.border(AppRadius.size18),
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
                  fontSize: AppTypography.size16,
                  fontWeight: AppTypography.semiBold,
                  color: textColor,
                ),
              ),
              const Spacer(),
              const SizedBox(width: AppSpacing.s24),
            ],
          ),
        ),
      ),
    );
  }
}


