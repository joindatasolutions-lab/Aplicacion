import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pedido.dart';

class PedidoService {
  static const String baseUrl =
      "https://script.google.com/macros/s/AKfycbyZ7JBbbNi48PQE4W_WqB-6vJyPBreeteRi6b1iY2glAifpantX3P4JlPr_AdJMt3ti8A/exec";


  static Future<List<Pedido>> getPedidos() async {
    final res = await http.get(Uri.parse("$baseUrl?modulo=pedidos"));
    if (res.statusCode != 200) throw Exception("Error ${res.statusCode}");
    final data = jsonDecode(res.body);

    print("📦 Datos crudos pedidos: $data");

    // Si el backend devuelve {"pedidos": [...]}
    final lista = data is Map ? data['pedidos'] ?? [] : data;
    return (lista as List).map((e) => Pedido.fromJson(e)).toList();
  }

  static Future<List<Pedido>> getProduccion() async {
    final res = await http.get(Uri.parse("$baseUrl?modulo=produccion"));
    if (res.statusCode != 200) throw Exception("Error ${res.statusCode}");
    final data = jsonDecode(res.body);

    print("📦 Datos crudos produccion: $data");

    final lista = data is Map ? data['produccion'] ?? [] : data;
    return (lista as List).map((e) => Pedido.fromJson(e)).toList();
  }

  static Future<List<Pedido>> getDomicilios() async {
    final res = await http.get(Uri.parse("$baseUrl?modulo=domicilios"));
    if (res.statusCode != 200) throw Exception("Error ${res.statusCode}");
    final data = jsonDecode(res.body);

    print("📦 Datos crudos domicilios: $data");

    final lista = data is Map ? data['domicilios'] ?? [] : data;
    return (lista as List).map((e) => Pedido.fromJson(e)).toList();
  }
}
