import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StatusBadgeWidget extends StatelessWidget {
  final String label;
  final Color? color;
  final double fontSize;

  const StatusBadgeWidget({
    super.key,
    required this.label,
    this.color,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppTheme.leadStatusColor(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withAlpha(31),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withAlpha(77), width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: badgeColor,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
