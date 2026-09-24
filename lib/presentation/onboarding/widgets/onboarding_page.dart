import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../utils/responsive.dart';
import '../onboarding_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final Widget bottomButtons;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.bottomButtons,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Column(
      children: [
        Expanded(
          child: Image.asset(
            data.image,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        Container(
          width: double.infinity,
          color: AppColors.background,
          padding: EdgeInsets.symmetric(
            horizontal: r.w(20),
            vertical: r.h(16),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: r.sp(20),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (data.description.isNotEmpty) ...[
                  SizedBox(height: r.h(8)),
                  Text(
                    data.description,
                    style: TextStyle(
                      fontSize: r.sp(13),
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
                SizedBox(height: r.h(20)),
                bottomButtons,
              ],
            ),
          ),
        ),
      ],
    );
  }
}