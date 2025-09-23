import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pedido.dart';
import '../screens/pedido_detalle.dart';

class PedidoCard extends StatelessWidget {
  final Pedido pedido;

  const PedidoCard({super.key, required this.pedido});

  Color _getEstadoColor(PedidoEstado estado) {
    switch (estado) {
      case PedidoEstado.pendiente: return Colors.yellow.shade600;
      case PedidoEstado.aprobado: return Colors.green.shade400;
      case PedidoEstado.rechazado: return Colors.red.shade300;
      case PedidoEstado.enPreparacion: return Colors.orange.shade300;
      case PedidoEstado.listoEnvio: return Colors.blue.shade300;
      case PedidoEstado.enCamino: return Colors.purple.shade300;
      case PedidoEstado.entregado: return Colors.greenAccent.shade400;
      case PedidoEstado.incidencia: return Colors.redAccent.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.2),
      margin: const EdgeInsets.all(10),
      color: const Color(0xFFFEFEFE),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: _getEstadoColor(pedido.estado).withOpacity(0.9),
          child: Text(
            pedido.id.split('-').last,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          "${pedido.cliente} • \$${pedido.total.toStringAsFixed(0)}",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "${pedido.resumen}\n${pedido.fecha}",
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PedidoDetalleScreen(pedido: pedido),
            ),
          );
        },
      ),
    );
  }
}
