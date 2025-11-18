import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'config/app_config.dart';
import 'core/di/injection.dart' as di;
import 'core/network/connectivity_service.dart';
import 'core/database/services/rutas_sync_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/cartera/presentation/bloc/socio_bloc.dart';
import 'features/cartera/presentation/bloc/socio_event.dart';
import 'features/rutas/presentation/bloc/rutas_bloc.dart';
import 'features/rutas/presentation/bloc/rutas_event.dart';
import 'features/seguimientos/presentation/bloc/seguimientos_bloc.dart';
import 'features/seguimientos/presentation/bloc/seguimientos_event.dart';
import 'features/cartera/presentation/bloc/cartera_bloc.dart';
import 'features/cartera/presentation/bloc/cartera_event.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize();
  
  MapboxOptions.setAccessToken(AppConfig.mapboxAccessToken);
  
  await di.initInjections();
  await _initializeOfflineServices();
  runApp(const MyApp());
}

Future<void> _initializeOfflineServices() async {
  try {
    // Initialize connectivity monitoring
    final connectivityService = di.sl<ConnectivityService>();
    await connectivityService.initialize();
    
    // Initialize sync service with auto-sync enabled
    final rutasSyncService = di.sl<RutasSyncService>();
    await rutasSyncService.initialize(enableAutoSync: true);
    
  } catch (e) {
    throw Exception('Error initializing offline services: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>()..add(const CheckAuthStatusEvent()),
        ),
        BlocProvider<RutasBloc>(
          create: (_) => di.sl<RutasBloc>()..add(const GetRutasEvent()),
        ),
        BlocProvider<SeguimientosBloc>(
          create: (_) => di.sl<SeguimientosBloc>()..add(const GetSeguimientosEvent()),
        ),
        BlocProvider<CarteraBloc>(
          create: (_) => di.sl<CarteraBloc>()..add(const GetCarterasEvent()),
        ),
        BlocProvider<SocioBloc>(
          create: (_) => di.sl<SocioBloc>()..add(const GetSociosEvent()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: AppConfig.appName,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
