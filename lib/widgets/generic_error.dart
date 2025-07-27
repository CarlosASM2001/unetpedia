import 'package:flutter/material.dart';

class GenericError extends StatelessWidget {
  const GenericError({super.key, this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Text(
      error ?? "Ha ocurrido un error inesperado.",
      textAlign: TextAlign.center,
    );
  }
}
