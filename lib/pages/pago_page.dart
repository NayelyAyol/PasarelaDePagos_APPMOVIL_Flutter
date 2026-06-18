import 'dart:math';

import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/supabase_service.dart';
import 'resultado_page.dart';

class PagoPage extends StatefulWidget {
  final Producto producto;

  const PagoPage({
    super.key,
    required this.producto,
  });

  @override
  State<PagoPage> createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  final formKey = GlobalKey<FormState>();

  final titularCtrl = TextEditingController();
  final tarjetaCtrl = TextEditingController();
  final expiracionCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();

  String simularPago() {
    return Random().nextBool()
        ? 'APROBADO'
        : 'RECHAZADO';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titularCtrl,
                decoration: const InputDecoration(
                  labelText: 'Titular',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: tarjetaCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número de tarjeta',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  }

                  if (value.length < 16) {
                    return 'Debe tener 16 dígitos';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: expiracionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Fecha de expiración',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: cvvCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  }

                  if (value.length != 3) {
                    return 'Debe tener 3 dígitos';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  final estado = simularPago();

                  await guardarPagoSupabase(
                    producto: widget.producto.nombre,
                    total: widget.producto.precio,
                    titular: titularCtrl.text,
                    tarjeta: tarjetaCtrl.text,
                    estado: estado,
                  );

                  if (!mounted) return;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ResultadoPage(estado: estado),
                    ),
                  );
                },
                child: const Text('Pagar ahora'),
              )
            ],
          ),
        ),
      ),
    );
  }
}