import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/domain/entities/auth_role.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../core/routing/routes.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/di/injection.dart' as di;
import 'custom_bottom_nav_bar.dart';
import 'global_connectivity_banner.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  NavBarItem _currentNavItem = NavBarItem.home;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentNavItem();
  }

  void _updateCurrentNavItem() {
    String location;
    try {
      location = GoRouterState.of(context).uri.path;
    } catch (e) {
      location = Routes.home;
    }

    setState(() {
      if (location == Routes.rutas) {
        _currentNavItem = NavBarItem.rutas;
      } else if (location == Routes.seguimiento || location == Routes.cartera) {
        _currentNavItem = NavBarItem.cartera;
      } else if (location == Routes.perfil) {
        _currentNavItem = NavBarItem.perfil;
      } else {
        _currentNavItem = NavBarItem.home;
      }
    });
  }

  void _onNavItemTapped(final NavBarItem item) {
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;
    AuthRole? userRole;
    if (authState is AuthAuthenticated) {
      userRole = authState.user.authRole;
    }
    switch (item) {
      case NavBarItem.home:
        context.go(Routes.home);
        break;
      case NavBarItem.rutas:
        context.go(Routes.rutas);
        break;
      case NavBarItem.center:
        _showCenterActionDialog();
        break;
      case NavBarItem.cartera:
        if (userRole == AuthRole.jefe) {
          context.go(Routes.seguimiento);
        } else {
          context.go(Routes.cartera);
        }
        break;
      case NavBarItem.perfil:
        context.go(Routes.perfil);
        break;
    }
  }

  void _showCenterActionDialog() {
    final authBloc = context.read<AuthBloc>();
    final authState = authBloc.state;
    AuthRole? userRole;
    if (authState is AuthAuthenticated) {
      userRole = authState.user.authRole;
    }
    
    // Si es jefe, navegar a aprobación de rutas
    if (userRole == AuthRole.jefe) {
      context.push(Routes.aprobacionRutas);
    } else {
      // Si es asesor, navegar a crear ruta
      context.push(Routes.crearRuta);
    }
  }

  @override
  Widget build(final BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (final context, final authState) {
        AuthRole? userRole;
        if (authState is AuthAuthenticated) {
          userRole = authState.user.authRole;
        }
        
        // Determinar si es asesor para mostrar banner global
        final bool isAsesor = userRole == AuthRole.asesor;
        
        return Scaffold(
          body: Column(
            children: [
              // Banner global de conectividad solo para asesores
              if (isAsesor)
                GlobalConnectivityBanner(
                  connectivityService: di.sl<ConnectivityService>(),
                ),
              // Contenido de la página
              Expanded(
                child: widget.child,
              ),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentNavItem,
            onTap: _onNavItemTapped,
            userRole: userRole,
          ),
        );
      },
    );
  }
}
