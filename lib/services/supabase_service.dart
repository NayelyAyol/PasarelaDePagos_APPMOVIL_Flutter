import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> guardarPagoSupabase({
  required String producto,
  required double total,
  required String titular,
  required String tarjeta,
  required String estado,
}) async {
  await supabase.from('pagos_simulados').insert({
    'producto': producto,
    'total': total,
    'titular': titular,
    'ultimos4': tarjeta.substring(tarjeta.length - 4),
    'estado': estado,
  });
}

Future<List<dynamic>> obtenerPagos() async {
  return await supabase
      .from('pagos_simulados')
      .select()
      .order('fecha', ascending: false);
}