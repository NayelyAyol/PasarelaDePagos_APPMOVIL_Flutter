import 'package:flutter/material.dart';
import '../models/producto.dart';
import 'resumen_pago.dart';
import 'historial_page.dart';

class ProductosPage extends StatelessWidget {
  const ProductosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistorialPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 26,
                child: Text(
                  producto.nombre[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                producto.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('\$${producto.precio.toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                child: const Text('Comprar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ResumenPage(producto: producto),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
