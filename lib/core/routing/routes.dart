abstract final class Routes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const rutas = '/rutas';
  static const seguimiento = '/seguimiento';
  static const cartera = '/cartera';
  static const allSocios = '/all-socios';
  static const socioDetail = '/socioDetail';
  static const perfil = '/perfil';
  static const settings = '/settings';
  static const seguimientoDiario = '/seguimiento-diario';
  static const actualizarDatos = '/actualizar-datos';
  static const creditos = '/creditos';
  static const creditoInfo = '/credito-info';
  static const registerSocio = '/registrar-socio';
  
  static const mapa = '/mapa';

  static const seguimientosList = '/seguimientos-list';
  static const asesorMonitoring = '/asesor-monitoring';
  static const seguimientoDetail = '/seguimiento-detail';
  static const creditoDetail = '/credito-detail';
  static const createSeguimiento = '/create-seguimiento';

  static const crearRuta = '/crear-ruta';
  static const rutaInfo = '/ruta-info';
  static const rutaSocios = '/ruta-socios';
  static const rutaEvidencia = '/ruta-evidencia';
  static const rutaCreada = '/ruta-creada';
  static const aprobacionRutas = '/aprobacion-rutas';
  
  static bool requiresAuth(final String route) {
    return route != splash && route != login;
  }
}