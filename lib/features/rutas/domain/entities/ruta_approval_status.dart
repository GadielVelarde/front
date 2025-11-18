import 'package:flutter/material.dart';

enum RutaApprovalStatus {
  pendiente('Pendiente', Colors.orange),
  aprobado('Aprobado', Colors.green),
  anulado('Anulado', Colors.red);

  final String displayName;
  final Color color;

  const RutaApprovalStatus(this.displayName, this.color);

  /// Obtener el estado desde un string
  static RutaApprovalStatus fromString(final String status) {
    switch (status.toLowerCase()) {
      case 'aprobado':
      case 'approved':
        return RutaApprovalStatus.aprobado;
      case 'anulado':
      case 'cancelled':
      case 'rejected':
        return RutaApprovalStatus.anulado;
      case 'pendiente':
      case 'pending':
      default:
        return RutaApprovalStatus.pendiente;
    }
  }

  /// Obtener el ícono según el estado
  IconData get icon {
    switch (this) {
      case RutaApprovalStatus.pendiente:
        return Icons.pending_actions;
      case RutaApprovalStatus.aprobado:
        return Icons.check_circle;
      case RutaApprovalStatus.anulado:
        return Icons.cancel;
    }
  }
}
