import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  static const _purple = Color(0xFF534AB7);
  static const _blue = Color(0xFF378ADD);

  String simularPago() => Random().nextBool() ? 'APROBADO' : 'RECHAZADO';

  bool validarExpiracion(String v) =>
      RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(v);

  Future<void> procesarPago() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => cargando = true);
    final estado = simularPago();
    await guardarPagoSupabase(
      producto: widget.producto.nombre,
      total: widget.producto.precio,
      titular: titularCtrl.text.trim(),
      tarjeta: tarjetaCtrl.text.replaceAll(' ', '').trim(),
      estado: estado,
    );
    if (!mounted) return;
    setState(() => cargando = false);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => ResultadoPage(estado: estado)));
  }

  @override
  void dispose() {
    titularCtrl.dispose(); tarjetaCtrl.dispose();
    expiracionCtrl.dispose(); cvvCtrl.dispose();
    super.dispose();
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
              // Badge de seguridad
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 16, color: Color(0xFF185FA5)),
                    SizedBox(width: 8),
                    Text('Conexión cifrada SSL · Datos protegidos',
                        style: TextStyle(fontSize: 12, color: Color(0xFF185FA5))),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Card resumen producto
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEEEDFE), Color(0xFFE6F1FB)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFAFA9EC)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.producto.nombre,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600,
                            color: Color(0xFF3C3489))),
                    const SizedBox(height: 6),
                    Text('\$${widget.producto.precio.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w600,
                            color: Color(0xFF3C3489))),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Titular (solo letras)
              TextFormField(
                controller: titularCtrl,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[a-zA-ZáéíóúÁÉÍÓÚüÜñÑ\s]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Titular de la tarjeta',
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Nombre completo',
                ),
                validator: (v) {
                  final val = v?.trim() ?? '';
                  if (val.isEmpty) return 'Ingrese el titular';
                  if (val.length < 3) return 'Nombre demasiado corto';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Número de tarjeta (solo dígitos, formato visual 0000 0000 0000 0000)
              TextFormField(
                controller: tarjetaCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Número de tarjeta',
                  prefixIcon: Icon(Icons.credit_card),
                  hintText: '0000 0000 0000 0000',
                  counterText: '',
                ),
                validator: (v) {
                  final digits = (v ?? '').replaceAll(' ', '');
                  if (digits.isEmpty) return 'Ingrese el número de tarjeta';
                  if (digits.length != 16) return 'Debe tener 16 dígitos';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  // Expiración
                  Expanded(
                    child: TextFormField(
                      controller: expiracionCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpDateFormatter(),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Expiración',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                        hintText: 'MM/YY',
                        counterText: '',
                      ),
                      validator: (v) {
                        final fecha = v?.trim() ?? '';
                        if (fecha.isEmpty) return 'Requerido';
                        if (!validarExpiracion(fecha)) return 'Formato MM/YY';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  // CVV
                  Expanded(
                    child: TextFormField(
                      controller: cvvCtrl,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 3,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        prefixIcon: Icon(Icons.lock_outline),
                        hintText: '•••',
                        counterText: '',
                      ),
                      validator: (v) {
                        final cvv = v?.trim() ?? '';
                        if (cvv.isEmpty) return 'Requerido';
                        if (cvv.length != 3) return '3 dígitos';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: cargando ? null : procesarPago,
                  icon: cargando
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.shield_outlined),
                  label: Text(cargando ? 'Procesando...' : 'Pagar ahora',
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Formateador que agrega espacio cada 4 dígitos: 1234 5678 9012 3456
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Formateador que inserta / después de MM
class _ExpDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll('/', '');
    String formatted = digits;
    if (digits.length > 2) {
      formatted = '${digits.substring(0, 2)}/${digits.substring(2)}';
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}