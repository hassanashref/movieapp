import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_colors.dart';

class CustomBtn extends StatelessWidget {
  final String title;
  final void Function()? onPressed;
  final bool isLoding;
  final Widget? icon;

  const CustomBtn({
    super.key,
    required this.title,
    this.isLoding = false,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        color: AppColors.primary,
        disabledColor: AppColors.background,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        borderRadius: BorderRadius.circular(16.r),
        onPressed: isLoding ? null : onPressed,
        child: AnimatedCrossFade(
          firstChild: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: 10.w),
              ],
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.background,
                ),
              ),
            ],
          ),
          secondChild: Center(
            child: SizedBox(
              height: 24.h,
              width: 24.h,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ),
          crossFadeState: isLoding
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }
}

