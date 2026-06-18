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
                MaterialPageRoute(
                  builder: (_) => const HistorialPage(),
                ),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(producto.nombre),
              subtitle: Text('\$${producto.precio}'),
              trailing: ElevatedButton(
                child: const Text('Comprar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ResumenPage(producto: producto),
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