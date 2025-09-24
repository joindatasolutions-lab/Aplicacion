// lib/presentation/widgets/order_card_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Añade 'intl' a tu pubspec.yaml
import '../../data/models/order_model.dart';

class OrderCardWidget extends StatelessWidget {
  final Order order;

  const OrderCardWidget({Key? key, required this.order}) : super(key: key);

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.aprobado:
      case OrderStatus.entregado:
      case OrderStatus.listoParaEnvio:
        return Colors.green.shade400; // Verde
      case OrderStatus.rechazado:
      case OrderStatus.incidenciaEnEntrega:
        return Colors.red.shade400; // Rojo
      case OrderStatus.pendiente:
      case OrderStatus.enPreparacion:
      case OrderStatus.enCamino:
      default:
        return Colors.orange.shade400; // Amarillo/Naranja
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'es_CO', symbol: '\$', decimalDigits: 0);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 6, color: _getStatusColor()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.id,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFF1E1E1E)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order.clientName,
                      style: TextStyle(fontSize: 14, color: Color(0xFF1E1E1E)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            order.status.toString().split('.').last,
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                          backgroundColor: _getStatusColor(),
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(
                          currencyFormat.format(order.totalAmount),
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}