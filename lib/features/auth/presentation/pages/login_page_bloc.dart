import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/routing/routes.dart';
import '../../presentation/bloc/auth_bloc.dart';
import '../../presentation/bloc/auth_event.dart';
import '../../presentation/bloc/auth_state.dart';
import '../../../../core/theme/theme.dart';
class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(final BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<AuthBloc>().add(
      LoginRequestedEvent(
        usuario: _usuarioController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (final context, final state) async {
              if (state is AuthAuthenticated) {
                await _requestLocationPermission();
                if (context.mounted) {
                  context.go(Routes.home);
                }
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (final context, final state) {
                final isLoading = state is AuthLoading;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 80),
                        Text(
                          'Inicia Sesión',
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Bienvenido de vuelta!',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 60),
                        SizedBox(
                          width: 350,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.inputBackground,
                                  borderRadius: BorderRadius.circular(
                                      AppThemeConstants.radiusInput),
                                ),
                                child: TextFormField(
                                  controller: _usuarioController,
                                  keyboardType: TextInputType.text,
                                  enabled: !isLoading,
                                  decoration: const InputDecoration(
                                    hintText: 'Usuario',
                                    hintStyle: TextStyle(
                                      color: AppColors.hintText,
                                      fontSize: AppThemeConstants.fontSizeLarge,
                                      fontWeight: AppThemeConstants.fontWeightMedium,
                                      fontFamily: AppThemeConstants.fontFamilyPrimary,
                                    ),
                                    contentPadding: EdgeInsets.only(
                                      top: 20,
                                      left: 20,
                                      right: 35,
                                      bottom: 20,
                                    ),
                                  ),
                                  validator: (final value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa tu usuario';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 29),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.inputBackground,
                                  borderRadius: BorderRadius.circular(
                                      AppThemeConstants.radiusInput),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  enabled: !isLoading,
                                  decoration: InputDecoration(
                                    hintText: 'Contraseña',
                                    hintStyle: const TextStyle(
                                      color: AppColors.hintText,
                                      fontSize: AppThemeConstants.fontSizeLarge,
                                      fontWeight: AppThemeConstants.fontWeightMedium,
                                      fontFamily: AppThemeConstants.fontFamilyPrimary,
                                    ),
                                    contentPadding: const EdgeInsets.only(
                                      top: 20,
                                      left: 20,
                                      right: 35,
                                      bottom: 20,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: AppColors.hintText,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (final value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa tu contraseña';
                                    }
                                    if (value.length < 6) {
                                      return 'La contraseña debe tener al menos 6 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 40),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: isLoading ? () {} : () => _handleLogin(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    disabledBackgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppThemeConstants.radiusButton),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                strokeWidth: 2.0,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Flexible(
                                              child: Text(
                                                'Iniciando Sesión...',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: AppThemeConstants.fontSizeLarge,
                                                  fontWeight: AppThemeConstants.fontWeightBold,
                                                  fontFamily: AppThemeConstants.fontFamilyPrimary,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                      )
                                      : const Text(
                                          'Iniciar Sesión',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppThemeConstants.fontSizeLarge,
                                            fontWeight: AppThemeConstants.fontWeightBold,
                                            fontFamily: AppThemeConstants.fontFamilyPrimary,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
