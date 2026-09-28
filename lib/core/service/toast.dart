import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movieapp/core/theme/app_colors.dart';

import '../../main.dart';

class Toast {
  static void show({
    required String title,
    ToastType type = ToastType.success,
  }) {
    if (navigatorKey.currentContext == null) return;
    final messenger = ScaffoldMessenger.maybeOf(navigatorKey.currentContext!);
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        elevation: 4,
        backgroundColor: const Color(0xFF1E1E1E),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: type == ToastType.success ? AppColors.primary : Colors.redAccent,
            width: 1.2,
          ),
        ),
        content: Row(
          children: [
            Icon(
              type == ToastType.success
                  ? Icons.check_circle_rounded
                  : Icons.error_outline_rounded,
              color: type == ToastType.success ? AppColors.primary : Colors.redAccent,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ToastType { error, success }

