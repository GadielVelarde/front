import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import '../../../core/routing/routes.dart';
import '../../../core/theme/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _checkAuthStatus();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _scale = 1.0;
        });
      }
    });
  }

  void _startExitAnimation() {
    setState(() {
      _opacity = 0.0;
      _scale = 1.2;
    });
  }

  Future<void> _checkAuthStatus() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    final authBloc = context.read<AuthBloc>();
    authBloc.add(const CheckAuthStatusEvent());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      final authState = authBloc.state;
      final isAuthenticated = authState is AuthAuthenticated;
      _startExitAnimation();
      await Future<void>.delayed(const Duration(milliseconds: 800));
      
      if (mounted) {
        if (isAuthenticated) {
          context.go(Routes.home);
        } else {
          context.go(Routes.login);
        }
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 800),
            child: AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/app/logo_norandino.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
