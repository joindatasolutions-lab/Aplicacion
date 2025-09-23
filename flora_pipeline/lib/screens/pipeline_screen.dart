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

  // 🔍 Búsqueda y filtros independientes
  String searchPedidos = "";
  String searchProduccion = "";
  String searchDomicilios = "";

  PedidoEstado? filtroPedidos;
  PedidoEstado? filtroProduccion;
  PedidoEstado? filtroDomicilios;

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
      body: Row(
        children: [
          _buildColumn(
            titulo: "PEDIDOS",
            future: futurePedidos,
            searchQuery: searchPedidos,
            filtroEstado: filtroPedidos,
            onSearchChanged: (v) => setState(() => searchPedidos = v.toLowerCase()),
            onFiltroChanged: (estado) => setState(() => filtroPedidos = estado),
          ),
          _buildColumn(
            titulo: "PRODUCCIÓN",
            future: futureProduccion,
            searchQuery: searchProduccion,
            filtroEstado: filtroProduccion,
            onSearchChanged: (v) => setState(() => searchProduccion = v.toLowerCase()),
            onFiltroChanged: (estado) => setState(() => filtroProduccion = estado),
          ),
          _buildColumn(
            titulo: "DOMICILIO",
            future: futureDomicilios,
            searchQuery: searchDomicilios,
            filtroEstado: filtroDomicilios,
            onSearchChanged: (v) => setState(() => searchDomicilios = v.toLowerCase()),
            onFiltroChanged: (estado) => setState(() => filtroDomicilios = estado),
          ),
        ],
      ),
    );
  }

  /// 🔧 Construcción de columnas con búsqueda y filtro propio
  Widget _buildColumn({
    required String titulo,
    required Future<List<Pedido>> future,
    required String searchQuery,
    required PedidoEstado? filtroEstado,
    required Function(String) onSearchChanged,
    required Function(PedidoEstado?) onFiltroChanged,
  }) {
    return Expanded(
      child: Column(
        children: [
          // 🔹 Encabezado de la columna
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey.shade200,
            child: Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),

          // 🔍 Barra de búsqueda por columna
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Buscar...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: onSearchChanged,
            ),
          ),

          // 🎛️ Barra de filtros por columna
          SizedBox(
            height: 45,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                _buildFiltroChip(null, "Todos", filtroEstado, onFiltroChanged),
                ...PedidoEstado.values.map(
                  (estado) => _buildFiltroChip(estado, estado.name, filtroEstado, onFiltroChanged),
                ),
              ],
            ),
          ),

          // 📋 Lista de pedidos filtrada
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

                // Aplicar búsqueda
                if (searchQuery.isNotEmpty) {
                  pedidos = pedidos.where((p) {
                    return p.cliente.toLowerCase().contains(searchQuery) ||
                        p.resumen.toLowerCase().contains(searchQuery) ||
                        p.id.toLowerCase().contains(searchQuery);
                  }).toList();
                }

                // Aplicar filtro por estado
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

  /// 🎛️ Chip de filtro reutilizable
  Widget _buildFiltroChip(
    PedidoEstado? estado,
    String label,
    PedidoEstado? filtroActual,
    Function(PedidoEstado?) onFiltroChanged,
  ) {
    final isSelected = filtroActual == estado;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onFiltroChanged(estado),
      ),
    );
  }
}
