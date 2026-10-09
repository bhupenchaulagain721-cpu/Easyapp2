import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Permanent Footer Branding for Easy App.
/// Mandated on Splash, Login, Registration, and Main screen bases.
/// Displays:
/// "Powered by"
/// "Republic Nepal TV & Advertising Pvt. Ltd."
class CompanyFooter extends StatelessWidget {
  final bool isDark;
  final EdgeInsetsGeometry padding;

  const CompanyFooter({
    super.key,
    this.isDark = false,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 14,
                height: 1,
                color: isDark ? Colors.white24 : AppColors.lightBorder,
              ),
              const SizedBox(width: 8),
              Text(
                'Powered by',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.white60 : AppColors.lightTextMuted,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 14,
                height: 1,
                color: isDark ? Colors.white24 : AppColors.lightBorder,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.tv_rounded,
                size: 13,
                color: AppColors.accent,
              ),
              const SizedBox(width: 5),
              Text(
                'Republic Nepal TV & Advertising Pvt. Ltd.',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: isDark ? AppColors.accentLight : AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'रिपब्लिक नेपाल टिभी एण्ड एडभरटाइजिङ प्रा. लि.',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white38 : AppColors.lightTextMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
