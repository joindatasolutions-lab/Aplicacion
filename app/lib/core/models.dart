class Order {
  final String pedido;
  final String estado;
  final String producto;
  final String fecha;
  final String fechaEntrega;
  final String identificacion;
  final String primerNombre;
  final String primerApellido;
  final String total;
  final String cuenta;
  // ... agrega los demás campos

  Order.fromJson(Map<String, dynamic> j)
      : pedido = j['Pedido'] ?? '',
        estado = j['Estado'] ?? 'Pendiente',
        producto = j['Producto'] ?? '',
        fecha = j['Fecha'] ?? '',
        fechaEntrega = j['Fecha de Entrega'] ?? '',
        identificacion = j['Identificacion'] ?? '',
        primerNombre = j['PrimerNombre'] ?? '',
        primerApellido = j['PrimerApellido'] ?? '',
        total = j['Total'] ?? '',
        cuenta = j['Cuenta'] ?? '';
}
