enum PedidoFase { pedidos, produccion, domicilio }

enum PedidoEstado {
  // Pedidos
  pendiente, aprobado, rechazado,
  // Producción
  enPreparacion, listoEnvio,
  // Domicilio
  enCamino, entregado, incidencia
}

class Pedido {
  final String id;
  final String cliente;
  final DateTime fecha;
  final PedidoFase fase;
  final PedidoEstado estado;
  final String resumen;
  final double total;

  Pedido({
    required this.id,
    required this.cliente,
    required this.fecha,
    required this.fase,
    required this.estado,
    required this.resumen,
    required this.total,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: (json['Pedido'] ?? json['N°Pedido'] ?? "").toString(),
      cliente: (json['Cliente'] ?? json['PrimerNombre'] ?? "Desconocido").toString(),
      fecha: json['Fecha'] != null
          ? DateTime.tryParse(json['Fecha'].toString()) ?? DateTime.now()
          : DateTime.now(),
      fase: PedidoFase.pedidos, // lo ajustas según el origen
      estado: PedidoEstado.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['Estado'] ?? json['Estado del Pedido'] ?? "pendiente").toLowerCase(),
        orElse: () => PedidoEstado.pendiente,
      ),
      resumen: (json['Producto'] ?? json['Nombre_Producto'] ?? "").toString(),
      total: double.tryParse(json['Total']?.toString() ?? json['Valor Cobrado']?.toString() ?? "0") ?? 0,
    );
  }

}
