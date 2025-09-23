import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../services/pedido_service.dart';
import '../widgets/pedido_card.dart';

class PipelineScreen extends StatefulWidget {
  const PipelineScreen({super.key});

  @override
  State<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends State<PipelineScreen> {
  late Future<List<Pedido>> futurePedidos;
  late Future<List<Pedido>> futureProduccion;
  late Future<List<Pedido>> futureDomicilios;

  String searchQuery = "";
  PedidoEstado? filtroEstado;

  @override
  void initState() {
    super.initState();
    futurePedidos = PedidoService.getPedidos();
    futureProduccion = PedidoService.getProduccion();
    futureDomicilios = PedidoService.getDomicilios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pipeline de Pedidos")),
      body: Column(
        children: [
          // 🔍 Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Buscar por cliente, producto o ID...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
            ),
          ),

          // 🎛️ Barra de filtros por estado
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildFiltroChip(null, "Todos"),
                ...PedidoEstado.values.map(
                  (estado) => _buildFiltroChip(estado, estado.name),
                ),
              ],
            ),
          ),

          // 📊 Tablero con las 3 columnas
          Expanded(
            child: Row(
              children: [
                _buildColumn("PEDIDOS", futurePedidos),
                _buildColumn("PRODUCCIÓN", futureProduccion),
                _buildColumn("DOMICILIO", futureDomicilios),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construcción de chips de filtro
  Widget _buildFiltroChip(PedidoEstado? estado, String label) {
    final isSelected = filtroEstado == estado;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            filtroEstado = estado;
          });
        },
      ),
    );
  }

  /// Construcción de columnas del tablero
  Widget _buildColumn(String titulo, Future<List<Pedido>> future) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade200,
            child: Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pedido>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                var pedidos = snapshot.data ?? [];

                // 🔎 Aplicar búsqueda
                if (searchQuery.isNotEmpty) {
                  pedidos = pedidos.where((p) {
                    return p.cliente.toLowerCase().contains(searchQuery) ||
                        p.resumen.toLowerCase().contains(searchQuery) ||
                        p.id.toLowerCase().contains(searchQuery);
                  }).toList();
                }

                // 🎛️ Aplicar filtro de estado
                if (filtroEstado != null) {
                  pedidos = pedidos.where((p) => p.estado == filtroEstado).toList();
                }

                if (pedidos.isEmpty) {
                  return const Center(child: Text("No hay datos"));
                }

                return ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (_, i) => PedidoCard(pedido: pedidos[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
