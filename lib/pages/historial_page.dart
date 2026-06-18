import 'package:flutter/material.dart';

import '../services/supabase_service.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: obtenerPagos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final pagos = snapshot.data!;

          if (pagos.isEmpty) {
            return const Center(
              child: Text('No hay pagos registrados'),
            );
          }

          return ListView.builder(
            itemCount: pagos.length,
            itemBuilder: (context, index) {
              final pago = pagos[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(pago['producto']),
                  subtitle: Text(
                    '${pago['estado']} - \$${pago['total']}',
                  ),
                  trailing: Text(
                    '****${pago['ultimos4']}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}