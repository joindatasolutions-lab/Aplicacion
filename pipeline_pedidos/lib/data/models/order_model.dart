// lib/data/models/order_model.dart

import 'package:flutter/material.dart';

enum OrderPhase { pedidos, produccion, domicilio }
enum OrderStatus { 
  // Pedidos
  pendiente, aprobado, rechazado,
  // Producción
  enPreparacion, listoParaEnvio,
  // Domicilio
  enCamino, entregado, incidenciaEnEntrega 
}

class Order {
  final String id;
  final String clientName;
  final DateTime date;
  final double totalAmount;
  OrderStatus status;
  OrderPhase phase;

  Order({
    required this.id,
    required this.clientName,
    required this.date,
    required this.totalAmount,
    required this.status,
    required this.phase,
  });

  // Esto es un ejemplo. Debes ajustarlo a la estructura REAL de tu JSON de AppSheet.
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['ID_Pedido'] ?? 'N/A',
      clientName: json['Nombre_Cliente'] ?? 'Sin nombre',
      date: DateTime.tryParse(json['Fecha']) ?? DateTime.now(),
      totalAmount: (json['Monto_Total'] as num?)?.toDouble() ?? 0.0,
      status: _statusFromString(json['Estado_Actual']),
      phase: _phaseFromString(json['Fase_Actual']),
    );
  }

  static OrderStatus _statusFromString(String? status) {
    return OrderStatus.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == status?.toLowerCase(),
      orElse: () => OrderStatus.pendiente,
    );
  }
  
  static OrderPhase _phaseFromString(String? phase) {
    return OrderPhase.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == phase?.toLowerCase(),
      orElse: () => OrderPhase.pedidos,
    );
  }
}