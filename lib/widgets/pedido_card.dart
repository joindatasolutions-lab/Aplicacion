import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../screens/pedido_detalle.dart';
import '../theme.dart';
import 'package:google_fonts/google_fonts.dart';


class PedidoCard extends StatelessWidget {
  final Pedido pedido;

  const PedidoCard({super.key, required this.pedido});

  // ---------------------------------------------------------------------------
  // 🌸 Conversión del enum PedidoEstado a texto legible para el usuario
  // ---------------------------------------------------------------------------
  String _estadoTexto(PedidoEstado e) {
    switch (e) {
      case PedidoEstado.pendiente:
        return "Pendiente";
      case PedidoEstado.aprobado:
        return "Aprobado";
      case PedidoEstado.rechazado:
        return "Rechazado";
      case PedidoEstado.enPreparacion:
        return "En Producción";
      case PedidoEstado.listoEnvio:
        return "Listo para Envío";
      case PedidoEstado.finalizado:
        return "Por Entregar";
      case PedidoEstado.enCamino:
        return "En Ruta";
      case PedidoEstado.entregado:
        return "Entregado";
      case PedidoEstado.incidencia:
        return "Incidencia";
      default:
        return "Pendiente";
    }
  }

  // ---------------------------------------------------------------------------
  // 🎨 Color personalizado según el estado del pedido
  // ---------------------------------------------------------------------------
  Color _getEstadoColor(PedidoEstado estado) {
    switch (estado) {
      case PedidoEstado.pendiente:
        return const Color(0xFFFFC107); // Amarillo
      case PedidoEstado.aprobado:
        return const Color(0xFF81C784); // Verde claro
      case PedidoEstado.rechazado:
        return Colors.red.shade300; // Rojo suave
      case PedidoEstado.enPreparacion:
        return const Color(0xFFB39DDB); // Lila suave
      case PedidoEstado.listoEnvio:
      case PedidoEstado.finalizado:
        return const Color(0xFFF8BBD0); // Rosa pastel
      case PedidoEstado.enCamino:
        return const Color(0xFF90CAF9); // Azul claro
      case PedidoEstado.entregado:
        return const Color(0xFF81C784); // Verde pastel
      case PedidoEstado.incidencia:
        return const Color(0xFFFF7043); // Naranja
      default:
        return Colors.grey.shade400;
    }
  }

  // ---------------------------------------------------------------------------
  // 🌸 Badge visual del estado con color y texto
  // ---------------------------------------------------------------------------
  Widget _buildEstadoBadge(PedidoEstado estado) {
    final color = _getEstadoColor(estado);
    final texto = _estadoTexto(estado);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        texto.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🧱 Construcción del card visual con diseño vertical
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final borderColor = _getEstadoColor(pedido.estado);

    // 🔧 Corrige casos donde el id no es numérico (por ejemplo, teléfono)
    final displayId = "#${pedido.id}";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6), //regular el circulo de borde 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
       //-- border: Border.all(color: borderColor.withOpacity(0.5), width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PedidoDetalleScreen(pedido: pedido)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 N° de pedido y cliente (en líneas separadas)
              Row(
                children: [
                  const Icon(Icons.local_florist, color: Color(0xFFC98989), size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "#${pedido.id}",
                    style: const TextStyle(
                      fontFamily: 'Roboto', // misma fuente base que las columnas
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF444444),
                      letterSpacing: 0.4,
                    ),
                  ),
                  
                ],
              ),




              Text(
                "• ${pedido.cliente}",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                "\$${pedido.total.toStringAsFixed(0)}",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                pedido.resumen,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
                ),
              ),              


              const SizedBox(height: 10),
              // 🎯 Estado
              Align(
                alignment: Alignment.centerLeft,
                child: _buildEstadoBadge(pedido.estado),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
