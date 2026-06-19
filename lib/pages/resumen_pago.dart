import 'package:flutter/material.dart';
import '../models/producto.dart';
import 'pago_page.dart';

class ResumenPage extends StatelessWidget {
  final Producto producto;
  const ResumenPage({super.key, required this.producto});

  static const _purple = Color(0xFF534AB7);
  static const _purpleLight = Color(0xFFEEEDFE);
  static const _purpleMid = Color(0xFFAFA9EC);
  static const _purpleDark = Color(0xFF3C3489);
  static const _blue = Color(0xFF378ADD);
  static const _blueLight = Color(0xFFE6F1FB);
  static const _blueDark = Color(0xFF185FA5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumen del pedido')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Icono con fondo degradado suave
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_purpleLight, _blueLight],
                ),
                border: Border.all(color: _purpleMid, width: 1.5),
              ),
              child: const Icon(Icons.shopping_bag_outlined,
                  size: 44, color: _purple),
            ),
            const SizedBox(height: 20),

            // Nombre del producto
            Text(
              producto.nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w600, color: _purpleDark),
            ),
            const SizedBox(height: 8),

            // Badge tipo suscripción
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: _blueLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Suscripción mensual',
                  style: TextStyle(fontSize: 12, color: _blueDark,
                      fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 24),

            // Card desglose de precios
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _purpleMid.withOpacity(0.4)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  _lineItem('Subtotal', producto.precio),
                  const SizedBox(height: 10),
                  _lineItem('Impuesto IVA (12%)', producto.precio * 0.12),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Divider(thickness: 0.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total a pagar',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                      Text(
                        '\$${(producto.precio * 1.12).toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700, color: _purple),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Nota de seguridad
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _blueLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield_outlined, size: 16, color: _blueDark),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pago seguro · Datos cifrados con SSL',
                      style: TextStyle(fontSize: 12, color: _blueDark),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Botón continuar
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Continuar al pago',
                    style: TextStyle(fontSize: 16)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PagoPage(producto: producto)),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _lineItem(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text('\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}