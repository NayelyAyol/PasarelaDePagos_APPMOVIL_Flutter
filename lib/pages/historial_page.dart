import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerPagos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final pagos = snapshot.data ?? [];

          if (pagos.isEmpty) {
            return const Center(child: Text('No hay pagos registrados'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: pagos.length,
            itemBuilder: (context, index) {
              final pago = pagos[index];
              final aprobado = pago['estado'] == 'APROBADO';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Icon(
                    aprobado ? Icons.check_circle : Icons.cancel,
                    color: aprobado ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    pago['producto'] ?? 'Producto',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${pago['estado']} - \$${pago['total']}'),
                  trailing: Text('****${pago['ultimos4'] ?? '0000'}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
