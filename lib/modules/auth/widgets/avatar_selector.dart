import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      viewportFraction: 0.38,
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
              double value = 0.0;
              if (_pageController.position.haveDimensions) {
                value = (_pageController.page ?? _selectedIndex.toDouble()) - index;
              } else {
                value = (_selectedIndex - index).toDouble();
              }

              // Scale: Center is 1.0, sides are ~0.65
              final double scale = (1 - (value.abs() * 0.35)).clamp(0.65, 1.0);

              return Center(
                child: Transform.scale(
                  scale: scale,
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
                      width: 130.w,
                      height: 130.h,
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}

