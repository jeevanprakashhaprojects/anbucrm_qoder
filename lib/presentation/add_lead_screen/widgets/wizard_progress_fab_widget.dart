import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class WizardProgressFabWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<bool> completedSteps;
  final double overallProgress;

  const WizardProgressFabWidget({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.completedSteps,
    this.overallProgress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    // Use overallProgress (based on filled required fields) if provided,
    // otherwise fall back to completed steps count
    final progress = overallProgress > 0
        ? overallProgress
        : completedSteps.where((c) => c).length / totalSteps;

    return SizedBox(
      width: 64,
      height: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.surface200,
              valueColor: AlwaysStoppedAnimation(
                progress >= 1.0 ? AppTheme.success : AppTheme.primary,
              ),
              strokeWidth: 4,
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: progress >= 1.0 ? AppTheme.success : AppTheme.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (progress >= 1.0 ? AppTheme.success : AppTheme.primary)
                      .withAlpha(77),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${(progress * 100).round()}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
