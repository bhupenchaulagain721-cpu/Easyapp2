import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../../features/home/presentation/providers/home_data_provider.dart';

/// Permanent Footer Branding for Easy App.
/// Mandated at the very bottom of every screen:
/// "Powered by " + app_config.footer_text (default: "रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि")
/// Do not abbreviate it.
class CompanyFooter extends ConsumerWidget {
  final bool isDark;
  final bool? isDarkMode;
  final String? footerText;
  final EdgeInsetsGeometry padding;

  const CompanyFooter({
    super.key,
    this.isDark = false,
    this.isDarkMode,
    this.footerText,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
  });

  static const String defaultFooterText = 'रिपब्लिक नेपाल टिभी एण्ड एड्भटाइजिङग प्रा लि';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveIsDark = isDarkMode ?? isDark;
    final configFooter = ref.watch(appConfigProvider).valueOrNull?.footerText;

    final String chosenText = (footerText != null && footerText!.trim().isNotEmpty)
        ? footerText!.trim()
        : (configFooter != null && configFooter.trim().isNotEmpty)
            ? configFooter.trim()
            : defaultFooterText;

    // Use full Nepali company name exactly, never an abbreviation, never English
    final effectiveFooterText = (chosenText.toLowerCase().contains('republic') || chosenText.isEmpty)
        ? defaultFooterText
        : chosenText;

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
                color: effectiveIsDark ? Colors.white24 : AppColors.lightBorder,
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.tv_rounded,
                size: 13,
                color: AppColors.accent,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Powered by $effectiveFooterText',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                    color: effectiveIsDark ? AppColors.accentLight : AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 14,
                height: 1,
                color: effectiveIsDark ? Colors.white24 : AppColors.lightBorder,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Easy App · All rights reserved',
            style: TextStyle(
              fontSize: 9,
              color: effectiveIsDark ? Colors.white38 : AppColors.lightTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
