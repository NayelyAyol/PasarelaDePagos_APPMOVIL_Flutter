import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial de pagos')),
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
            return const Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.receipt_long_outlined, size: 56, color: Colors.grey),
                SizedBox(height: 12),
                Text('Sin pagos registrados', style: TextStyle(color: Colors.grey)),
              ]),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: pagos.length,
            itemBuilder: (context, index) {
              final pago = pagos[index];
              final aprobado = pago['estado'] == 'APROBADO';
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: aprobado
                        ? const Color(0xFFEAF3DE)
                        : const Color(0xFFFCEBEB),
                    child: Icon(
                      aprobado ? Icons.check : Icons.close,
                      color: aprobado ? const Color(0xFF3B6D11) : const Color(0xFFA32D2D),
                    ),
                  ),
                  title: Text(pago['producto'] ?? 'Producto',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${pago['estado']} · ****${pago['ultimos4'] ?? '0000'}',
                    style: TextStyle(
                        color: aprobado
                            ? const Color(0xFF3B6D11)
                            : const Color(0xFFA32D2D),
                        fontSize: 12),
                  ),
                  trailing: Text('\$${pago['total']}',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: aprobado
                              ? const Color(0xFF534AB7)
                              : const Color(0xFFA32D2D))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}