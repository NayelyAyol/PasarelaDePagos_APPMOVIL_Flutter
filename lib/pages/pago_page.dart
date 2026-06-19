import 'dart:math';

import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/supabase_service.dart';
import 'resultado_page.dart';

class PagoPage extends StatefulWidget {
  final Producto producto;

  const PagoPage({super.key, required this.producto});

  @override
  State<PagoPage> createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  final formKey = GlobalKey<FormState>();

  final titularCtrl = TextEditingController();
  final tarjetaCtrl = TextEditingController();
  final expiracionCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();

  bool cargando = false;

  String simularPago() {
    return Random().nextBool() ? 'APROBADO' : 'RECHAZADO';
  }

  bool validarExpiracion(String value) {
    final regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
    return regex.hasMatch(value);
  }

  Future<void> procesarPago() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => cargando = true);

    final estado = simularPago();

    await guardarPagoSupabase(
      producto: widget.producto.nombre,
      total: widget.producto.precio,
      titular: titularCtrl.text.trim(),
      tarjeta: tarjetaCtrl.text.trim(),
      estado: estado,
    );

    if (!mounted) return;

    setState(() => cargando = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ResultadoPage(estado: estado)),
    );
  }

  @override
  void dispose() {
    titularCtrl.dispose();
    tarjetaCtrl.dispose();
    expiracionCtrl.dispose();
    cvvCtrl.dispose();
    super.dispose();
  }

  InputDecoration decoracion(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pago seguro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.producto.nombre,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total a pagar: \$${widget.producto.precio.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: titularCtrl,
                decoration: decoracion('Titular de la tarjeta', Icons.person),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingrese el titular';
                  }
                  if (value.trim().length < 3) {
                    return 'Nombre demasiado corto';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: tarjetaCtrl,
                keyboardType: TextInputType.number,
                maxLength: 16,
                decoration: decoracion('Número de tarjeta', Icons.credit_card),
                validator: (value) {
                  final tarjeta = value?.trim() ?? '';

                  if (tarjeta.isEmpty) {
                    return 'Ingrese el número de tarjeta';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(tarjeta)) {
                    return 'Solo se permiten números';
                  }
                  if (tarjeta.length != 16) {
                    return 'Debe tener 16 dígitos';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 5),

              TextFormField(
                controller: expiracionCtrl,
                keyboardType: TextInputType.datetime,
                decoration: decoracion(
                  'Fecha de expiración MM/YY',
                  Icons.date_range,
                ),
                validator: (value) {
                  final fecha = value?.trim() ?? '';

                  if (fecha.isEmpty) {
                    return 'Ingrese la fecha de expiración';
                  }
                  if (!validarExpiracion(fecha)) {
                    return 'Formato válido: MM/YY';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: cvvCtrl,
                keyboardType: TextInputType.number,
                maxLength: 3,
                obscureText: true,
                decoration: decoracion('CVV', Icons.lock),
                validator: (value) {
                  final cvv = value?.trim() ?? '';

                  if (cvv.isEmpty) {
                    return 'Ingrese el CVV';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(cvv)) {
                    return 'Solo se permiten números';
                  }
                  if (cvv.length != 3) {
                    return 'Debe tener 3 dígitos';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: cargando ? null : procesarPago,
                  icon: cargando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.payment),
                  label: Text(cargando ? 'Procesando...' : 'Pagar ahora'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
