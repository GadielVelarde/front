import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import 'custom_bottom_nav_bar.dart';

class NavbarItem extends StatelessWidget {
  const NavbarItem({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.item,
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final NavBarItem currentIndex;
  final void Function(NavBarItem p1) onTap;
  final NavBarItem item;
  final Widget icon;
  final Widget activeIcon;
  final String label;

  @override
  Widget build(final BuildContext context) {
    final isActive = currentIndex == item;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(item),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DefaultTextStyle(
                style: TextStyle(
                  color: isActive ? AppColors.onPrimary : AppColors.textPrimary,
                ),
                child: isActive ? activeIcon : icon,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? AppColors.onPrimary : AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                  fontFamily: AppThemeConstants.fontFamilyPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
