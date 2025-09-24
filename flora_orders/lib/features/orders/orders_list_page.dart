import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../widgets/brand_header.dart';
import 'order_detail_page.dart';

class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage> {
  // Datos de ejemplo (luego se reemplazan por API)
  final List<Map<String, String>> _orders = [
    {
      "Pedido": "1001",
      "Fecha": "2025-09-22",
      "Cliente": "Ana María Gómez",
      "Producto": "Flora Box Mediana Tierra",
      "Estado": "Pendiente",
      "Total": "120000"
    },
    {
      "Pedido": "1002",
      "Fecha": "2025-09-22",
      "Cliente": "Carlos Pérez",
      "Producto": "Ramo Rosas Premium",
      "Estado": "Aprobado",
      "Total": "185000"
    },
    {
      "Pedido": "1003",
      "Fecha": "2025-09-23",
      "Cliente": "Laura Díaz",
      "Producto": "Caja Tulipanes",
      "Estado": "No Aprobado",
      "Total": "95000"
    },
  ];

  String _query = "";

  @override
  Widget build(BuildContext context) {
    final filtered = _orders.where((o) {
      final q = _query.toLowerCase();
      return o.values.any((v) => v.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/flora_logo.png',
                height: 28, width: 28, fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Pedidos'),
          ],
        ),
      ),
      body: Column(
        children: [
          const FloraBrandHeader(subtitle: 'Tienda de flores'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(
                hintText: 'Buscar por pedido, cliente o producto...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final o = filtered[i];
                return _OrderCard(
                  pedido: o["Pedido"]!,
                  fecha: o["Fecha"]!,
                  cliente: o["Cliente"]!,
                  producto: o["Producto"]!,
                  estado: o["Estado"]!,
                  total: o["Total"]!,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailPage(order: o),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================== CARD DE PEDIDO (faltaba esta clase) ==================
class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.pedido,
    required this.fecha,
    required this.cliente,
    required this.producto,
    required this.estado,
    required this.total,
    required this.onTap,
  });

  final String pedido, fecha, cliente, producto, estado, total;
  final VoidCallback onTap;

  Color _statusColor(String status) {
    switch (status) {
      case "Aprobado":
        return const Color(0xFF6FB07F); // verde suave
      case "No Aprobado":
        return const Color(0xFFCB6E6E); // rojo suave
      default:
        return kFloraRose; // pendiente -> rosa
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: kFloraBlush,
                child: Text(
                  pedido,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: kFloraTaupe,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cliente,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(producto),
                    const SizedBox(height: 4),
                    Text("Fecha: $fecha"),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _statusColor(estado).withOpacity(.12),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: _statusColor(estado), width: 1),
                    ),
                    child: Text(
                      estado,
                      style: TextStyle(
                        color: _statusColor(estado),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("\$${_fmt(total)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _fmt(String v) {
    final n = int.tryParse(v) ?? 0;
    final s = n.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
      b.write(s[i]);
    }
    return b.toString();
  }
}
