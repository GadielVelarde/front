import 'package:flutter/material.dart';

class AppUtils {
  AppUtils._();
  static void showSnackBar(
    final BuildContext context, {
    required final String message,
    final Color? backgroundColor,
    final Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.grey[800],
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  static void showLoadingDialog(final BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (final context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  static void hideLoadingDialog(final BuildContext context) {
    Navigator.of(context).pop();
  }
  static bool isValidEmail(final String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  static bool isValidPassword(final String password) {
    return password.length >= 6;
  }
  static String formatDate(final DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  static String formatTime(final TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  static String capitalize(final String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
  }
  static String getInitials(final String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return '';
  }
  static Future<bool?> showConfirmationDialog(
    final BuildContext context, {
    required final String title,
    required final String message,
    final String confirmText = 'Confirmar',
    final String cancelText = 'Cancelar',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (final context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
  static void safeNavigate(final BuildContext context, final String route) {
    if (Navigator.canPop(context)) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (final route) => false,
      );
    } else {
      Navigator.pushNamed(context, route);
    }
  }
  static Color getStatusColor(final String status) {
    switch (status.toLowerCase()) {
      case 'activo':
      case 'completado':
      case 'success':
        return Colors.green;
      case 'pendiente':
      case 'proceso':
      case 'warning':
        return Colors.orange;
      case 'inactivo':
      case 'cancelado':
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
