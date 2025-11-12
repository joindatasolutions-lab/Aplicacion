import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../models/pedido.dart';

class EstadoBadge extends StatelessWidget {
  final PedidoEstado estado;

  const EstadoBadge({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.estadoColor[estado] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15), // fondo suave
        border: Border.all(color: color, width: 1.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        estado.name.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
