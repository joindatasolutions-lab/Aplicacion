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
    // breakpoint un poco más amplio para web
    final isMobile = MediaQuery.of(context).size.width < 900;

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
                setState(() => searchQuery = value.toLowerCase());
              },
            ),
          ),
          // 📊 Vista adaptativa
          Expanded(
            child: isMobile ? _buildMobileView() : _buildDesktopView(),
          ),
        ],
      ),
    );
  }

  /// ----- VISTA MÓVIL (pestañas)
  Widget _buildMobileView() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.purple,
            tabs: [
              Tab(text: "PEDIDOS"),
              Tab(text: "PRODUCCIÓN"),
              Tab(text: "DOMICILIO"),
            ],
          ),
          Expanded(
            child: TabBarView(
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

  /// ----- VISTA ESCRITORIO (3 columnas con altura fija para evitar Expanded sin límites)
  Widget _buildDesktopView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight; // altura disponible
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 420, height: h, child: _buildColumn("PEDIDOS", futurePedidos)),
              SizedBox(width: 420, height: h, child: _buildColumn("PRODUCCIÓN", futureProduccion)),
              SizedBox(width: 420, height: h, child: _buildColumn("DOMICILIO", futureDomicilios)),
            ],
          ),
        );
      },
    );
  }

  /// Construcción de chips de filtro (por si luego lo usas en UI)
  Widget _buildFiltroChip(PedidoEstado? estado, String label) {
    final isSelected = filtroEstado == estado;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => filtroEstado = estado),
      ),
    );
  }

  /// ----- COLUMNA (sin Expanded externo; el alto lo aporta el padre)
  Widget _buildColumn(String titulo, Future<List<Pedido>> future) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          color: Colors.grey.shade200,
          child: Text(
            titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

              // 🔎 Búsqueda
              if (searchQuery.isNotEmpty) {
                final q = searchQuery;
                pedidos = pedidos.where((p) =>
                  p.cliente.toLowerCase().contains(q) ||
                  p.resumen.toLowerCase().contains(q) ||
                  p.id.toLowerCase().contains(q)
                ).toList();
              }

              // 🎛️ Filtro por estado
              if (filtroEstado != null) {
                pedidos = pedidos.where((p) => p.estado == filtroEstado).toList();
              }

              // 🛠️ Filtrar por columna
              if (titulo == "PEDIDOS") {
                pedidos = pedidos.where((p) =>
                  p.estado == PedidoEstado.pendiente ||
                  p.estado == PedidoEstado.rechazado
                ).toList();
              } else if (titulo == "PRODUCCIÓN") {
                pedidos = pedidos.where((p) =>
                  p.estado == PedidoEstado.aprobado ||
                  p.estado == PedidoEstado.enPreparacion ||
                  p.estado == PedidoEstado.pendiente ||
                  p.estado == PedidoEstado.listoEnvio
                ).toList();
              } else if (titulo == "DOMICILIO") {
                pedidos = pedidos.where((p) =>
                  p.estado == PedidoEstado.enCamino ||
                  p.estado == PedidoEstado.entregado ||
                  p.estado == PedidoEstado.incidencia
                ).toList();
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
    );
  }
}
