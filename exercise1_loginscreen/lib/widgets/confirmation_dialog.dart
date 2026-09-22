import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onDelete;
  final String actionButtonText;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onDelete,
    required this.actionButtonText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      icon: Icon(
        Icons.warning_amber_rounded,
        size: 36,
        color: theme.colorScheme.error,
      ),
      title: Text(title),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
          ),
          onPressed: () {
            Navigator.pop(context); // Cierra el diálogo
            onDelete(); // Ejecuta la acción de borrado
          },
          child: Text(actionButtonText),
        ),
      ],
    );
  }
}
