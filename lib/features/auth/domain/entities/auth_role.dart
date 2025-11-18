enum AuthRole {
  jefe,
  asesor,
  admin;
  String toJson() => name;
  static AuthRole fromString(final String role) {
    return AuthRole.values.firstWhere(
      (final e) => e.name == role.toLowerCase(),
      orElse: () => AuthRole.asesor,
    );
  }
  bool get isJefe => this == AuthRole.jefe;
  bool get isAsesor => this == AuthRole.asesor;
  bool get isAdmin => this == AuthRole.admin;
  
  bool get isJefeOrAdmin => this == AuthRole.jefe || this == AuthRole.admin;
}
