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

  /// Vista para celulares (con pestañas)
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
  
  /// Vista para escritorio (tres columnas en fila)
  Widget _buildDesktopView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 300, child: _buildColumn("PEDIDOS", futurePedidos)),
          SizedBox(width: 300, child: _buildColumn("PRODUCCIÓN", futureProduccion)),
          SizedBox(width: 300, child: _buildColumn("DOMICILIO", futureDomicilios)),
        ],
      ),
    );
  }
  

  @override
  void initState() {
    super.initState();
    futurePedidos = PedidoService.getPedidos();
    futureProduccion = PedidoService.getProduccion();
    futureDomicilios = PedidoService.getDomicilios();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600; // 👈 Cambia según umbral

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
          // 📊 Vista adaptativa
          Expanded(
            child: isMobile ? _buildMobileView() : _buildDesktopView(),
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
                // 🎛️ Aplicar filtro de estado
                if (filtroEstado != null) {
                  pedidos = pedidos.where((p) => p.estado == filtroEstado).toList();
                }

                // 🛠️ Filtrar pedidos según la columna/módulo
                if (titulo == "PEDIDOS") {
                  pedidos = pedidos.where((p) =>
                      p.estado == PedidoEstado.pendiente ||
                      p.estado == PedidoEstado.rechazado).toList();
                } else if (titulo == "PRODUCCIÓN") {
                  pedidos = pedidos.where((p) =>
                      p.estado == PedidoEstado.aprobado ||
                      p.estado == PedidoEstado.enPreparacion ||
                      p.estado == PedidoEstado.pendiente ||
                      p.estado == PedidoEstado.listoEnvio).toList();
                } else if (titulo == "DOMICILIO") {
                  pedidos = pedidos.where((p) =>
                      p.estado == PedidoEstado.enCamino ||
                      p.estado == PedidoEstado.entregado ||
                      p.estado == PedidoEstado.incidencia).toList();
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
