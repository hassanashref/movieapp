import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/app_colors.dart';

class AvatarSelector extends StatefulWidget {
  final ValueChanged<String>? onAvatarSelected;
  final String? selectedAvatar;
  final int initialIndex;

  static const List<String> avatarsList = [
    'assets/images/gamer (1).png',
    'assets/images/gamer (2).png',
    'assets/images/gamer (3).png',
    'assets/images/gamer (4).png',
    'assets/images/gamer (5).png',
    'assets/images/gamer (6).png',
    'assets/images/gamer (7).png',
    'assets/images/gamer (8).png',
    'assets/images/gamer (9).png',
  ];

  const AvatarSelector({
    super.key,
    this.onAvatarSelected,
    this.selectedAvatar,
    this.initialIndex = 1,
  });

  static Future<void> showAvatarBottomSheet(
    BuildContext context, {
    required String currentAvatar,
    required ValueChanged<String> onSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Choose Your Avatar",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: avatarsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final avatarPath = avatarsList[index];
                  final isSelected = avatarPath == currentAvatar;
                  return GestureDetector(
                    onTap: () {
                      onSelected(avatarPath);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: EdgeInsets.all(isSelected ? 4.r : 2.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: isSelected ? 3 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          avatarPath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  @override
  State<AvatarSelector> createState() => _AvatarSelectorState();
}

class _AvatarSelectorState extends State<AvatarSelector> {
  late PageController _pageController;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    if (widget.selectedAvatar != null) {
      final index = AvatarSelector.avatarsList.indexOf(widget.selectedAvatar!);
      _selectedIndex = index != -1 ? index : widget.initialIndex;
    } else {
      _selectedIndex = widget.initialIndex;
    }
    _pageController = PageController(
      viewportFraction: 0.35,
      initialPage: _selectedIndex,
    );
  }

  @override
  void didUpdateWidget(covariant AvatarSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedAvatar != null &&
        widget.selectedAvatar != oldWidget.selectedAvatar) {
      final index = AvatarSelector.avatarsList.indexOf(widget.selectedAvatar!);
      if (index != -1 && index != _selectedIndex) {
        setState(() {
          _selectedIndex = index;
        });
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: AvatarSelector.avatarsList.length,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
          widget.onAvatarSelected?.call(AvatarSelector.avatarsList[index]);
        },
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = (_pageController.page ?? _selectedIndex.toDouble()) -
                    index;
                value = (1 - (value.abs() * 0.3)).clamp(0.72, 1.0);
              } else {
                value = index == _selectedIndex ? 1.0 : 0.72;
              }

              final isCurrent = index == _selectedIndex;

              return Center(
                child: SizedBox(
                  height: Curves.easeOut.transform(value) * 140.h,
                  width: Curves.easeOut.transform(value) * 140.w,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCurrent && value > 0.95
                            ? AppColors.primary
                            : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: isCurrent && value > 0.95
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.35),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: child,
                  ),
                ),
              );
            },
            child: GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                widget.onAvatarSelected?.call(AvatarSelector.avatarsList[index]);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 6.w),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    AvatarSelector.avatarsList[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
