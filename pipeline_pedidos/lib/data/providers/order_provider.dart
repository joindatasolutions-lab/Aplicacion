// lib/data/providers/order_provider.dart

import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../services/appsheet_service.dart';

class OrderProvider with ChangeNotifier {
  final AppSheetService _service = AppSheetService();

  List<Order> _allOrders = [];
  bool isLoading = true;
  String? errorMessage;

  // Getters para filtrar pedidos por fase para cada columna
  List<Order> get pedidos => _allOrders.where((o) => o.phase == OrderPhase.pedidos).toList();
  List<Order> get produccion => _allOrders.where((o) => o.phase == OrderPhase.produccion).toList();
  List<Order> get domicilio => _allOrders.where((o) => o.phase == OrderPhase.domicilio).toList();

  Future<void> fetchOrders() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _allOrders = await _service.getOrders();
    } catch (e) {
      errorMessage = "Error al cargar los datos.";
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> moveOrder(String orderId, OrderPhase targetPhase) async {
    Order? orderToMove = _allOrders.firstWhere((o) => o.id == orderId);
    
    OrderPhase originalPhase = orderToMove.phase;
    orderToMove.phase = targetPhase;
    
    // Lógica para asignar el primer estado de la nueva fase
    if (targetPhase == OrderPhase.produccion) {
      orderToMove.status = OrderStatus.enPreparacion;
    } else if (targetPhase == OrderPhase.domicilio) {
      orderToMove.status = OrderStatus.enCamino;
    }
    
    notifyListeners(); // Actualización optimista de la UI

    try {
      await _service.updateOrderState(orderId, orderToMove.status, targetPhase);
    } catch (e) {
      // Si falla, revertimos el cambio en la UI
      orderToMove.phase = originalPhase;
      // Revertir el estado también si es necesario
      fetchOrders(); // La forma más simple es recargar todo
      errorMessage = "Error de sincronización. Inténtalo de nuevo.";
      notifyListeners();
    }
  }
}