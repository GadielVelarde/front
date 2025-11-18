import 'package:flutter/material.dart';

class SeguimientoField extends StatelessWidget {
  const SeguimientoField({
    super.key,
    required this.context,
    required this.labelText,
    required this.valueText,
    this.bottomSheet,
    this.dialog,
    this.suffixIcon,
    this.onTap,
  });

  final BuildContext context;
  final String labelText;
  final String valueText;
  final Widget? bottomSheet;
  final Widget? dialog;
  final Widget? suffixIcon;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final bool isInteractive = bottomSheet != null || dialog != null || onTap != null;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: GestureDetector(
        onTap: isInteractive ? () {
          if (onTap != null) {
            onTap!();
          } else if (bottomSheet != null) {
            showModalBottomSheet<void>(
              context: context,
              builder: (final context) => bottomSheet!,
            );
          } else if (dialog != null) {
            showDialog<void>(
              context: context,
              builder: (final context) => dialog!,
            );
          }
        } : null,
        child: InputDecorator(
          decoration: InputDecoration(
            fillColor: Colors.white,
            labelText: labelText,
            labelStyle: const TextStyle(
              color: Color(0xFF858587),
              fontSize: 14,
            ),
            suffixIcon: suffixIcon ?? (isInteractive ? const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFFABABAD),
            ) : null),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFABABAD)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 10,
            ),
          ),
          child: Text(
            valueText,
            style: const TextStyle(
              color: Color(0xFF191C1F),
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}