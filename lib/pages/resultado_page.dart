import 'package:flutter/material.dart';

class ResultadoPage extends StatelessWidget {
  final String estado;

  const ResultadoPage({
    super.key,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado'),
      ),
      body: Center(
        child: Text(
          estado,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: estado == 'APROBADO'
                ? Colors.green
                : Colors.red,
          ),
        ),
      ),
    );
  }
}