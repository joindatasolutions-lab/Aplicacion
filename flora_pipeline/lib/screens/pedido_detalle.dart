import 'package:flutter/material.dart';
import '../models/pedido.dart';

class PedidoDetalleScreen extends StatelessWidget {
  final Pedido pedido;

  const PedidoDetalleScreen({super.key, required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pedido ${pedido.id}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cliente: ${pedido.cliente}", style: const TextStyle(fontSize: 16)),
            Text("Fecha: ${pedido.fecha}"),
            Text("Estado actual: ${pedido.estado.name}"),
            const Divider(),
            Text("Resumen: ${pedido.resumen}"),
            Text("Monto total: \$${pedido.total.toStringAsFixed(0)}"),
            const Divider(),
            Text("Historial de estados: (por implementar)"),
          ],
        ),
      ),
    );
  }
}
