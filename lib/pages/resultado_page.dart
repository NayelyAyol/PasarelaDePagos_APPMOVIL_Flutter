import 'package:flutter/material.dart';

class ResultadoPage extends StatelessWidget {
  final String estado;

  const ResultadoPage({
    super.key,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    final aprobado = estado == 'APROBADO';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  aprobado ? Icons.check_circle : Icons.cancel,
                  size: 90,
                  color: aprobado ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 18),
                Text(
                  estado,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: aprobado ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  aprobado
                      ? 'El pago fue procesado correctamente.'
                      : 'El pago fue rechazado. Intenta nuevamente.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Volver'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}