// models/pedido.dart

enum PedidoFase { pedidos, produccion, domicilio }

enum PedidoEstado {
  // Pedidos
  pendiente, aprobado, rechazado,
  // Producción
  enPreparacion, listoEnvio, finalizado,
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

// ---------- Normaliza estado ----------
PedidoEstado _mapEstado(dynamic v) {
  var s = _s(v).toLowerCase().trim();
  s = s
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ó', 'o')
      .replaceAll('ú', 'u');

  // --- PEDIDOS ---
  if (s.contains('aprobado')) return PedidoEstado.aprobado;
  if (s.contains('pendiente')) return PedidoEstado.pendiente;
  if (s.contains('rechazado')) return PedidoEstado.rechazado;

  // --- PRODUCCIÓN ---
  if (s.contains('en producción') || s.contains('en produccion') ||
      s.contains('produccion') || s.contains('en preparación') ||
      s.contains('en preparacion') || s.contains('preparacion')) {
    return PedidoEstado.enPreparacion;
  }

  if (s.contains('listo envío') || s.contains('listo envio') || s.contains('listo')) {
    return PedidoEstado.listoEnvio;
  }

  if (s.contains('terminado') || s.contains('finalizado') ||
      s.contains('finalizados') || s.contains('por entregar') ||
      s.contains('por recoger')) {
    return PedidoEstado.finalizado;
  }

  // --- DOMICILIO ---
  if (s.contains('en camino') || s.contains('camino') ||
      s.contains('en ruta') || s.contains('ruta')) {
    return PedidoEstado.enCamino;
  }

  if (s.contains('entregado') || s.contains('entregados')) {
    return PedidoEstado.entregado;
  }

  if (s.contains('incidencia')) return PedidoEstado.incidencia;

  // Valor por defecto
  return PedidoEstado.pendiente;
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
    // ID
    // ID — incluye minúsculas y variantes
    final id = _s(
      json['Pedido'] ??
      json['pedido'] ??
      json['N°Pedido'] ??
      json['n_pedido'] ??
      json['id'] ??  // 👈 para terminados / entregados
      ''
    ).trim();


    // Cliente
    final cliente = _s(
      json['Cliente'] ??
      json['cliente'] ??  // 👈 soporta minúsculas
      _joinNonEmpty([
        json['PrimerNombre'],
        json['SegundoNombre'],
        json['PrimerApellido'],
        json['SegundoApellido'],
      ])
    ).trim();   


    // Fecha
    final fecha = _toDate(
      json['Fecha'] ?? json['Fecha de Entrega'] ?? json['Hora de Registro'],
      fallback: DateTime.now(),
    );

    // Fase (pedidos, producción o domicilio)
    PedidoFase fase;
    if (json.containsKey('Nombre_Producto')) {
      fase = PedidoFase.produccion;
    } else if (json.containsKey('Destinatario') ||
        json.containsKey('Direccion') ||
        json.containsKey('Dirección de Entrega') ||
        json.containsKey('telefonoDestino') ||
        json.containsKey('TelefonoDestino')) {
      fase = PedidoFase.domicilio;
    } else {
      fase = PedidoFase.pedidos;
    }

    // Estado — normalizado a minúsculas antes de mapear
    final rawEstado = _s(
          json['Estado'] ??
          json['estado'] ?? // 👈 NUEVO: para terminados y entregados
          json['Estado del Pedido'] ??
          json['Estado Domicilio'] ??
          'pendiente'
        ).trim().toLowerCase();
    

    final estado = _mapEstado(rawEstado);

    // Resumen
    final resumen = _s(
      json['Producto'] ??
      json['Nombre_Producto'] ??
      json['resumen'] ?? // 👈 nuevo
      'Sin descripción'
    ).trim();

    // Total
    final total = _toDouble(
      json['Total'] ??
      json['Valor Cobrado'] ??
      json['total'] ?? // 👈 nuevo
      0
    );


    // Log de depuración
    print("🧾 Pedido ID=$id → Estado detectado: $rawEstado | Fase: $fase");

    return Pedido(
      id: id.isNotEmpty ? id : 'Sin ID',
      cliente: cliente.isNotEmpty ? cliente : 'Desconocido',
      fecha: fecha,
      fase: fase,
      estado: estado,
      resumen: resumen,
      total: total,
    );
  }
}