import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroine/heroine.dart';
import 'package:seguimiento_norandino/shared/presentation/pages/home/screens/map_screen.dart';
import '../../features/auth/presentation/pages/login_page_bloc.dart';
import '../../features/cartera/presentation/screens/actualizar_datos_screen.dart';
import '../../features/cartera/presentation/screens/credito_info_screen.dart';
import '../../features/cartera/presentation/screens/creditos_screen.dart';
import '../../features/cartera/presentation/screens/register_socio_screen.dart';
import '../../features/cartera/presentation/screens/seguimiento_screen.dart';
import '../../features/rutas/domain/entities/ruta_approval_status.dart';
import '../../features/rutas/presentation/pages/rutas_page.dart';
import '../../features/rutas/presentation/screens/aprobacion_rutas_screen.dart';
import '../../features/rutas/presentation/screens/crear_ruta_screen.dart';
import '../../features/rutas/presentation/screens/registrar_evidencia_screen.dart';
import '../../features/rutas/presentation/screens/ruta_creada_screen.dart';
import '../../features/rutas/presentation/screens/ruta_detalle_aprobacion_screen.dart';
import '../../features/rutas/presentation/screens/ruta_info_screen.dart';
import '../../features/rutas/presentation/screens/ruta_socios_screen.dart';
import '../../features/seguimientos/presentation/pages/seguimientos_list_page.dart';
import '../../features/seguimientos/presentation/pages/asesor_monitoring_page.dart';
import '../../features/seguimientos/presentation/pages/seguimiento_detail_page.dart';
import '../../features/seguimientos/presentation/pages/credito_detail_page.dart';
import '../../features/seguimientos/presentation/pages/create_seguimiento_page.dart';
import '../../shared/presentation/widgets/error_404_screen.dart';
import '../../shared/presentation/widgets/main_layout.dart';
import '../../shared/presentation/widgets/splash_screen.dart';
import '../../shared/presentation/pages/home/home_page.dart';
import '../../shared/presentation/pages/profile/perfil_page.dart';
import '../../features/cartera/presentation/pages/cartera_screen.dart';
import '../../features/cartera/presentation/pages/all_socios_screen.dart';
import '../../features/cartera/presentation/pages/socio_detail_screen.dart';
import 'routes.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: Routes.splash,
    observers: [HeroineController()],
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (final context, final state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        builder: (final context, final state) => const LoginPageBloc(),
      ),
      ShellRoute(
        builder: (final context, final state, final child) {
          return MainLayout(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: Routes.home,
            pageBuilder: (final context, final state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const HomePage(),
                transitionsBuilder: (final context, final animation, final secondaryAnimation, final child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: Routes.rutas,
            pageBuilder: (final context, final state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const RutasPage(),
                transitionsBuilder: (final context, final animation, final secondaryAnimation, final child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: Routes.seguimiento,
            pageBuilder: (final context, final state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const SeguimientosListPage(),
                transitionsBuilder: (final context, final animation, final secondaryAnimation, final child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: Routes.cartera,
            pageBuilder: (final context, final state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const CarteraScreen(),
                transitionsBuilder: (final context, final animation, final secondaryAnimation, final child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: Routes.perfil,
            pageBuilder: (final context, final state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const PerfilPage(),
                transitionsBuilder: (final context, final animation, final secondaryAnimation, final child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '${Routes.cartera}${Routes.socioDetail}/:socioId',
        name: Routes.socioDetail,
        builder: (final context, final state) => SocioDetailScreen(
          socioId: state.pathParameters['socioId']!,
        ),
      ),
      GoRoute(
        path: Routes.seguimientoDiario,
        builder: (final context, final state) => const SeguimientoScreen(),
      ),
      GoRoute(
        path: Routes.actualizarDatos,
        builder: (final context, final state) => const ActualizarDatosScreen(),
      ),
      GoRoute(
        path: Routes.registerSocio,
        builder: (final context, final state) => const RegisterSocioScreen(),
      ),
      GoRoute(
        path: Routes.allSocios,
        builder: (final context, final state) => const AllSociosScreen(),
      ),
      GoRoute(
        path: '${Routes.creditos}/:socioId',
        pageBuilder: (final context, final state) {
          final nombreSocio = state.uri.queryParameters['nombreSocio'];
          final socioId = state.pathParameters['socioId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: CreditosScreen(
              nombreSocio: nombreSocio,
              socioId: socioId,
            ),
            transitionsBuilder: (final context, final animation, final secondaryAnimation, final child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            reverseTransitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),
      GoRoute(
        path: '${Routes.creditoInfo}/:creditoId',
        pageBuilder: (final context, final state) {
          final creditoId = state.pathParameters['creditoId']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: CreditoInfoScreen(creditoId: creditoId),
            transitionsBuilder: (final context, final animation, final secondaryAnimation, final child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            reverseTransitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),
      GoRoute(
        path: Routes.seguimientosList,
        builder: (final context, final state) => const SeguimientosListPage(),
      ),
      GoRoute(
        path: '${Routes.asesorMonitoring}/:asesorName',
        builder: (final context, final state) {
          return Heroine(
            tag: 'asesor-${state.pathParameters['asesorName']}',
            child: AsesorMonitoringPage(
              asesorName: state.pathParameters['asesorName']!,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.seguimientoDetail,
        builder: (final context, final state) {
          final socioName = state.uri.queryParameters['socioName'] ?? 'Nombre del Socio';
          final fechaSeguimiento = state.uri.queryParameters['fechaSeguimiento'] ?? '18 de Septiembre de 2025';
          final creditoAsociado = state.uri.queryParameters['creditoAsociado'] ?? 'Credito Nro 1';
          final resultado = state.uri.queryParameters['resultado'] ?? 'Acuerdo de pago';
          final fechaAcordada = state.uri.queryParameters['fechaAcordada'] ?? '28 de Septiembre de 2025';
          final comentario = state.uri.queryParameters['comentario'] ?? 'Retraso por motivos familiares';
          
          return Heroine(
            tag: 'seguimiento-$socioName-$fechaSeguimiento',
            child: SeguimientoDetailPage(
              socioName: socioName,
              fechaSeguimiento: fechaSeguimiento,
              creditoAsociado: creditoAsociado,
              resultado: resultado,
              fechaAcordada: fechaAcordada,
              comentario: comentario,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.creditoDetail,
        pageBuilder: (final context, final state) {
          final creditoNro = state.uri.queryParameters['creditoNro'] ?? 'Credito Nro 1';
          final tipoCredito = state.uri.queryParameters['tipoCredito'] ?? 'Crédito Capitalización';
          final saldoCapital = state.uri.queryParameters['saldoCapital'] ?? 'S/ 15000';
          final deudaTotal = state.uri.queryParameters['deudaTotal'] ?? 'S/18000';
          final tasaInteres = state.uri.queryParameters['tasaInteres'] ?? '18%';
          final fechaVencimiento = state.uri.queryParameters['fechaVencimiento'] ?? '05 de Julio de 2025';
          final ultimaFechaPago = state.uri.queryParameters['ultimaFechaPago'] ?? '05 de Junio de 2025';
          final diasMora = state.uri.queryParameters['diasMora'] ?? '5';
          final cuotasPagadas = state.uri.queryParameters['cuotasPagadas'] ?? '5 de 12';
          final socioAsociado = state.uri.queryParameters['socioAsociado'] ?? 'José Domingo Quispe Lopez';
          
          return CustomTransitionPage(
            key: state.pageKey,
            child: CreditoDetailPage(
              creditoNro: creditoNro,
              tipoCredito: tipoCredito,
              saldoCapital: saldoCapital,
              deudaTotal: deudaTotal,
              tasaInteres: tasaInteres,
              fechaVencimiento: fechaVencimiento,
              ultimaFechaPago: ultimaFechaPago,
              diasMora: diasMora,
              cuotasPagadas: cuotasPagadas,
              socioAsociado: socioAsociado,
            ),
            transitionsBuilder: (final context, final animation, final secondaryAnimation, final child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            reverseTransitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),
      GoRoute(
        path: Routes.createSeguimiento,
        builder: (final context, final state) => const CreateSeguimientoPage(),
      ),
      // Rutas - Routes
      GoRoute(
        path: Routes.crearRuta,
        builder: (final context, final state) => const CrearRutaScreen(),
      ),
      GoRoute(
        path: '${Routes.rutaInfo}/:rutaId',
        builder: (final context, final state) {
          final approvalStatusStr = state.uri.queryParameters['approvalStatus'];
          final approvalStatus = approvalStatusStr != null
              ? RutaApprovalStatus.fromString(approvalStatusStr)
              : RutaApprovalStatus.pendiente;
          
          return RutaInfoScreen(
            rutaId: state.pathParameters['rutaId']!,
            approvalStatus: approvalStatus,
          );
        },
      ),
      GoRoute(
        path: '${Routes.rutaSocios}/:rutaId',
        builder: (final context, final state) => RutaSociosScreen(
          rutaId: state.pathParameters['rutaId']!,
        ),
      ),
      GoRoute(
        path: '${Routes.rutaEvidencia}/:rutaId',
        builder: (final context, final state) => RegistrarEvidenciaScreen(
          rutaId: state.pathParameters['rutaId']!,
          socioDni: state.uri.queryParameters['socioDni'],
        ),
      ),
      GoRoute(
        path: '${Routes.rutaCreada}/:rutaId/:nombreRuta',
        builder: (final context, final state) => RutaCreadaScreen(
          rutaId: state.pathParameters['rutaId']!,
          nombreRuta: state.pathParameters['nombreRuta']!,
        ),
      ),
      GoRoute(
        path: Routes.aprobacionRutas,
        builder: (final context, final state) => const AprobacionRutasScreen(),
      ),
      GoRoute(
        path: '${Routes.aprobacionRutas}/:id',
        builder: (final context, final state) {
          final id = state.pathParameters['id']!;
          return RutaDetalleAprobacionScreen(rutaId: id);
        },
      ),
      GoRoute(
        path: Routes.mapa,
        builder: (final context, final state) {
          return const MapboxScreen();
        },
      ),
    ],
    errorBuilder: (final context, final state) {
      return Error404Screen(path: state.uri.path);
    },
  );

  static GoRouter get router => _router;
}

