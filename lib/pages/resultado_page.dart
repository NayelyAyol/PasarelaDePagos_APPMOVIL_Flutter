import 'package:flutter/material.dart';

class ResultadoPage extends StatelessWidget {
  final String estado;
  const ResultadoPage({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final aprobado = estado == 'APROBADO';
    final color = aprobado ? const Color(0xFF3B6D11) : const Color(0xFFA32D2D);
    final bgColor = aprobado ? const Color(0xFFEAF3DE) : const Color(0xFFFCEBEB);

    return Scaffold(
      appBar: AppBar(title: const Text('Resultado del pago')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 52, backgroundColor: bgColor,
              child: Icon(
                aprobado ? Icons.check_rounded : Icons.close_rounded,
                size: 56, color: color,
              ),
            ),
            const SizedBox(height: 22),
            Text(estado,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: color)),
            const SizedBox(height: 10),
            Text(
              aprobado
                  ? 'Tu pago fue procesado correctamente.\nRecibirás un correo de confirmación.'
                  : 'El pago fue rechazado.\nVerifica los datos e intenta nuevamente.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, height: 1.6),
            ),
            const SizedBox(height: 28),
            if (aprobado)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEDFE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(children: [
                  Text('Referencia de transacción',
                      style: TextStyle(fontSize: 12, color: Color(0xFF534AB7))),
                  SizedBox(height: 4),
                  Text('#TXN-2024-8847',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                          color: Color(0xFF3C3489))),
                ]),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF534AB7)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver', style: TextStyle(color: Color(0xFF534AB7))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}