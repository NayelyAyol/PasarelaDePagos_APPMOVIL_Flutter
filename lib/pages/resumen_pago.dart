import 'package:flutter/material.dart';
import '../models/producto.dart';
import 'pago_page.dart';

class ResumenPage extends StatelessWidget {
  final Producto producto;

  const ResumenPage({
    super.key,
    required this.producto,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              producto.nombre,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 10),
            Text(
              'Total: \$${producto.precio}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text('Continuar al pago'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PagoPage(producto: producto),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}