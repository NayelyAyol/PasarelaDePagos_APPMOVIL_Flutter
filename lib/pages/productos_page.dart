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
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HistorialPage())),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: productos.length,
        itemBuilder: (context, index) {
          final producto = productos[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF534AB7),
                child: Text(producto.nombre[0],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
              ),
              title: Text(producto.nombre,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('\$${producto.precio.toStringAsFixed(2)}',
                  style: const TextStyle(color: Color(0xFF534AB7), fontWeight: FontWeight.w500)),
              trailing: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF534AB7),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ResumenPage(producto: producto))),
                child: const Text('Comprar'),
              ),
            ),
          );
        },
      ),
    );
  }
}