import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../features/auth/domain/entities/auth_role.dart';
import 'nav_bar_item.dart';

enum NavBarItem {
  home,
  rutas,
  center,
  cartera,
  perfil,
}

class CustomBottomNavBar extends StatelessWidget {
  final NavBarItem currentIndex;
  final void Function(NavBarItem) onTap;
  final AuthRole? userRole;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.userRole,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavItems(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavItems() {
    if (userRole?.isJefeOrAdmin == true) {
      return [
        NavbarItem(currentIndex: currentIndex, onTap: onTap, item: NavBarItem.home, icon: const Icon(Icons.home_outlined, size: 24), activeIcon: const Icon(Icons.home, size: 24, color: Colors.white), label: 'Inicio'),
        NavbarItem(currentIndex: currentIndex, onTap: onTap, item: NavBarItem.rutas, icon: const ImageIcon(AssetImage('assets/icons/icons_route.png'), size: 24), activeIcon: const ImageIcon(AssetImage('assets/icons/icons_route.png'), size: 24, color: Colors.white), label: 'Rutas'),
        _buildCenterButton(),
        NavbarItem(currentIndex: currentIndex, onTap: onTap, item: NavBarItem.cartera, icon: const Icon(Icons.people_outline, size: 24), activeIcon: const Icon(Icons.people, size: 24, color: Colors.white), label: 'Seguimiento'),
        NavbarItem(currentIndex: currentIndex, onTap: onTap, item: NavBarItem.perfil, icon: const Icon(Icons.person_outline, size: 24), activeIcon: const Icon(Icons.person, size: 24, color: Colors.white), label: 'Perfil'),
      ];
    } else {
      return [
        NavbarItem(currentIndex: currentIndex, onTap: onTap, item: NavBarItem.home, icon: const Icon(Icons.home_outlined, size: 24), activeIcon: const Icon(Icons.home, size: 24, color: Colors.white), label: 'Inicio'),
        NavbarItem(currentIndex: currentIndex, onTap: onTap, item: NavBarItem.rutas, icon: const Icon(Icons.map_outlined, size: 24), activeIcon: const Icon(Icons.map, size: 24, color: Colors.white), label: 'Rutas'),
        _buildCenterButton(),
        NavbarItem(currentIndex: currentIndex, onTap: onTap, item: NavBarItem.cartera, icon: const Icon(Icons.people_outline, size: 24), activeIcon: const Icon(Icons.people, size: 24, color: Colors.white), label: 'Cartera'),
        NavbarItem(currentIndex: currentIndex, onTap: onTap, item: NavBarItem.perfil, icon: const Icon(Icons.person_outline, size: 24), activeIcon: const Icon(Icons.person, size: 24, color: Colors.white), label: 'Perfil'),
      ];
    }
  }

  Widget _buildCenterButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(NavBarItem.center),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 53,
                height: 53,
                decoration: BoxDecoration(
                  color: AppColors.onPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowWithOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  (userRole?.isJefeOrAdmin == true) ? Icons.check : Icons.route_outlined,
                  color: AppColors.primary,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}