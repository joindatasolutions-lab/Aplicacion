//LECTURA DE GOOGLE SHEET
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pedido.dart';

class PedidoService {
  static const String baseUrl =
      //"https://script.google.com/macros/s/AKfycbxlvmJYksqalPz4rR8kHen2aDhZ94XSLQI5jQTRHMlAwi-lK9GIj56kQzdQT4NIbrbzxA/exec";
      "https://script.google.com/macros/s/AKfycbwNrfH-DmuO2Vm7ul95VwPitvqLSu_zWGtZMl7tbHnjzR83wNxsUKJY4VM51YHWWTu-xw/exec";
  // -----------------------------------------------------------------------------
  // 🔹 MÉTODO GENERAL REUTILIZABLE PARA TODOS LOS MÓDULOS
  // -----------------------------------------------------------------------------
  static Future<List<Pedido>> _fetchModulo(String modulo) async {
    final url = Uri.parse("$baseUrl?modulo=$modulo");
    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception("Error ${res.statusCode} al cargar módulo $modulo");
    }

    // Decodifica y normaliza el JSON recibido
    final decoded = jsonDecode(res.body);
    print("📦 [$modulo] Datos crudos: $decoded");

    // Manejo flexible de estructura { "modulo": [...] } o lista directa
    final lista = decoded is Map
        ? decoded[modulo] ?? decoded.values.firstOrNull ?? []
        : decoded;

    // Normaliza estados antes de parsear
    final pedidos = (lista as List)
        .map((e) {
          // Clona y limpia datos en minúscula para el estado
          final Map<String, dynamic> item = Map<String, dynamic>.from(e);
          if (item.containsKey('estado')) {
            item['estado'] = item['estado'].toString().toLowerCase().trim();
          } else if (item.containsKey('Estado')) {
            item['Estado'] = item['Estado'].toString().toLowerCase().trim();
          } else if (item.containsKey('Estado del Pedido')) {
            item['Estado del Pedido'] =
                item['Estado del Pedido'].toString().toLowerCase().trim();
          }
            else if (item.containsKey('Estado Domicilio')) {
            item['Estado Domicilio'] = item['Estado Domicilio'].toString().toLowerCase().trim();
          }

          return Pedido.fromJson(item);
        })
        .toList();

    return pedidos;
  }

  // -----------------------------------------------------------------------------
  // 🔹 MODULOS BASE
  // -----------------------------------------------------------------------------

  static Future<List<Pedido>> getPedidos() async =>
      _fetchModulo("pedidos");

  static Future<List<Pedido>> getProduccion() async =>
      _fetchModulo("produccion");

  //static Future<List<Pedido>> getDomicilios() async =>
  //    _fetchModulo("domicilios");

  static Future<List<Pedido>> getDomicilios() async {
    final res = await http.get(Uri.parse("$baseUrl?modulo=domicilios"));
    if (res.statusCode != 200) throw Exception("Error ${res.statusCode}");
    final data = jsonDecode(res.body);

    print("📦 Datos crudos domicilios: $data");

    final lista = data is Map ? data['domicilios'] ?? [] : data;

    // 👇 Agrega estas líneas de depuración
    for (var i = 0; i < lista.length; i++) {
      final item = lista[i];
      print("🧩 Registro #$i -> Estado Domicilio: ${item['Estado Domicilio']}");
    }

    return (lista as List).map((e) => Pedido.fromJson(e)).toList();
}


  //------------------------------------------------------------------------------
  //SI QUIERO AGREGAR OTRO MODULO DE PEDIDO, AGREGO PRIMERO ESTAS LINEAS DE PEDIDO
  // LEEN EL ESTADO DE GOOGLE SHEET DE LA HOJA PRODUCCION
  //EL SIGUIENTE PASO ES ADICIONAR UNAS LINEAS EN PIPELINE_SCREEN
  //------------------------------------------------------------------------------

  static Future<List<Pedido>> getTerminados() async =>
      _fetchModulo("terminados");

  //-----------------------------------------------------------------------------

  static Future<List<Pedido>> getEntregados() async =>
      _fetchModulo("entregados");
}

// -----------------------------------------------------------------------------
// 🔹 EXTENSIÓN ÚTIL PARA NO GENERAR ERRORES SI EL MAP NO TIENE LA CLAVE ESPERADA
// -----------------------------------------------------------------------------
extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
