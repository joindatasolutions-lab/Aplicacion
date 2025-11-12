// lib/data/services/appsheet_service.dart

import 'package:dio/dio.dart';
import '../models/order_model.dart';

class AppSheetService {
  final Dio _dio = Dio();
  final String _apiKey = "YOUR_APPSHEET_API_KEY"; // <-- ¡REEMPLAZA ESTO!
  final String _baseUrl = "https://api.appsheet.com/api/v2/apps/..."; // <-- ¡REEMPLAZA ESTO!

  AppSheetService() {
    _dio.options.headers['ApplicationAccessKey'] = _apiKey;
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<List<Order>> getOrders() async {
    try {
      // Reemplaza 'Tabla_Pedidos' con el nombre de tu tabla
      final response = await _dio.post(
        '$_baseUrl/tables/Tabla_Pedidos/Action',
        data: {
          "Action": "Find",
          "Properties": {},
          "Rows": []
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['Rows'] ?? response.data;
        return data.map((json) => Order.fromJson(json)).toList();
      } else {
        throw Exception("Error al obtener los pedidos");
      }
    } catch (e) {
      print("Error en getOrders: $e");
      // Para desarrollo, puedes devolver datos de ejemplo en caso de error
      return []; 
    }
  }

  Future<void> updateOrderState(String orderId, OrderStatus newStatus, OrderPhase newPhase) async {
    try {
      await _dio.post(
        '$_baseUrl/tables/Tabla_Pedidos/Action',
        data: {
          "Action": "Edit",
          "Properties": {},
          "Rows": [
            {
              "ID_Pedido": orderId, // Asegúrate que la columna clave sea esta
              "Estado_Actual": newStatus.toString().split('.').last,
              "Fase_Actual": newPhase.toString().split('.').last,
            }
          ]
        },
      );
    } catch (e) {
      print("Error al actualizar el pedido: $e");
      throw Exception("No se pudo actualizar el pedido");
    }
  }
}