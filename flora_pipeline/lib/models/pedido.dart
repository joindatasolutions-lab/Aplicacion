// models/pedido.dart

enum PedidoFase { pedidos, produccion, domicilio }

enum PedidoEstado {
  // Pedidos
  pendiente, aprobado, rechazado,
  // Producción
  enPreparacion, listoEnvio,
  // Domicilio
  enCamino, entregado, incidencia,
}

// ---------- Helpers de parseo seguro ----------
String _s(dynamic v) => (v ?? '').toString();

double _toDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  final t = _s(v).trim();
  if (t.isEmpty) return 0;
  // quita separadores y símbolos comunes
  final clean = t.replaceAll(RegExp(r'[^\d\.\-]'), '');
  return double.tryParse(clean) ?? 0;
}

DateTime _toDate(dynamic v, {DateTime? fallback}) {
  if (v == null) return fallback ?? DateTime.now();
  if (v is DateTime) return v;
  final t = _s(v).trim();
  if (t.isEmpty) return fallback ?? DateTime.now();
  try {
    return DateTime.parse(t);
  } catch (_) {
    return fallback ?? DateTime.now();
  }
}

String _joinNonEmpty(Iterable<dynamic> parts) =>
    parts.map(_s).map((e) => e.trim()).where((e) => e.isNotEmpty).join(' ');

// Normaliza estado con sinónimos y acentos
PedidoEstado _mapEstado(dynamic v) {
  final s = _s(v).toLowerCase().trim();

  switch (s) {
    case 'aprobado':
      return PedidoEstado.aprobado;
    case 'pendiente':
      return PedidoEstado.pendiente;
    case 'rechazado':
      return PedidoEstado.rechazado;
    case 'en preparación':
    case 'en preparacion':
    case 'preparacion':
      return PedidoEstado.enPreparacion;
    case 'listo envío':
    case 'listo envio':
    case 'listo':
      return PedidoEstado.listoEnvio;
    case 'en camino':
      return PedidoEstado.enCamino;
    case 'entregado':
      return PedidoEstado.entregado;
    case 'incidencia':
      return PedidoEstado.incidencia;
    default:
      return PedidoEstado.pendiente;
  }
}

// ---------- Modelo ----------
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
    // ID → Pedido o N°Pedido (cualquier tipo → String)
    final id = _s(json['Pedido'] ?? json['N°Pedido']).trim();

    // Cliente → Cliente o combinación de nombres (sin dobles espacios)
    final cliente = _s(json['Cliente']).trim().isNotEmpty
        ? _s(json['Cliente']).trim()
        : _joinNonEmpty([
            json['PrimerNombre'],
            json['SegundoNombre'],
            json['PrimerApellido'],
            json['SegundoApellido'],
          ]);

    // Fecha → acepta ISO string / DateTime / vacío
    final fecha = _toDate(
      json['Fecha'] ?? json['Fecha de Entrega'] ?? json['Hora de Registro'],
      fallback: DateTime.now(),
    );

    // Fase → heurística un poco más amplia
    // - Si trae "Producto" o "Total" típico de venta → pedidos
    // - Si trae "Nombre_Producto" → producción
    // - Si trae campos de entrega → domicilio
    PedidoFase fase;
    if (json.containsKey('Nombre_Producto')) {
      fase = PedidoFase.produccion;
    } else if (json.containsKey('Destinatario') ||
        json.containsKey('Direccion') ||
        json.containsKey('teléfonoDestino') ||
        json.containsKey('telefonoDestino')) {
      fase = PedidoFase.domicilio;
    } else {
      fase = PedidoFase.pedidos;
    }

    // Estado normalizado
    final estado = _mapEstado(
      json['Estado'] ?? json['Estado del Pedido'] ?? 'pendiente',
    );

    // Resumen → Producto/Nombre_Producto o “Sin descripción”
    final resumen = _s(json['Producto'] ?? json['Nombre_Producto']).trim().isNotEmpty
        ? _s(json['Producto'] ?? json['Nombre_Producto']).trim()
        : 'Sin descripción';

    // Total → Total o Valor Cobrado (soporta int/double/string con símbolos)
    final total = _toDouble(json['Total'] ?? json['Valor Cobrado'] ?? 0);

    return Pedido(
      id: id,
      cliente: cliente.isNotEmpty ? cliente : 'Desconocido',
      fecha: fecha,
      fase: fase,
      estado: estado,
      resumen: resumen,
      total: total,
    );
  }
}
