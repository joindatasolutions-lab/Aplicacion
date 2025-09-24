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
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: AppBar(title: const Text("Pipeline de Pedidos")),
      body: Column(
        children: [
          // 🔍 Búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Buscar por cliente, producto o ID...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
            ),
          ),
          Expanded(child: isMobile ? _buildMobileView() : _buildDesktopView()),
        ],
      ),
    );
  }

  // ------------------ VISTA MÓVIL (SIN HEADER)
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
                _columnBody(futurePedidos, scope: "PEDIDOS"),
                _columnBody(futureProduccion, scope: "PRODUCCIÓN"),
                _columnBody(futureDomicilios, scope: "DOMICILIO"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ VISTA ESCRITORIO (CON HEADER)
  Widget _buildDesktopView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 420,
                height: h,
                child: Column(
                  children: [
                    _columnHeader("PEDIDOS"),
                    Expanded(child: _columnBody(futurePedidos, scope: "PEDIDOS")),
                  ],
                ),
              ),
              SizedBox(
                width: 420,
                height: h,
                child: Column(
                  children: [
                    _columnHeader("PRODUCCIÓN"),
                    Expanded(child: _columnBody(futureProduccion, scope: "PRODUCCIÓN")),
                  ],
                ),
              ),
              SizedBox(
                width: 420,
                height: h,
                child: Column(
                  children: [
                    _columnHeader("DOMICILIO"),
                    Expanded(child: _columnBody(futureDomicilios, scope: "DOMICILIO")),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------ HEADER (solo escritorio)
  Widget _columnHeader(String titulo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade200,
      child: Text(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  // ------------------ BODY (común a móvil y escritorio)
  Widget _columnBody(Future<List<Pedido>> future, {required String scope}) {
    return FutureBuilder<List<Pedido>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        var pedidos = snapshot.data ?? [];

        // 🔎 búsqueda
        if (searchQuery.isNotEmpty) {
          final q = searchQuery;
          pedidos = pedidos.where((p) =>
            p.cliente.toLowerCase().contains(q) ||
            p.resumen.toLowerCase().contains(q) ||
            p.id.toLowerCase().contains(q)
          ).toList();
        }

        // 🎚 filtro por estado (si lo usas)
        if (filtroEstado != null) {
          pedidos = pedidos.where((p) => p.estado == filtroEstado).toList();
        }

        // 🧭 filtrar según columna
        if (scope == "PEDIDOS") {
          pedidos = pedidos.where((p) =>
            p.estado == PedidoEstado.pendiente ||
            p.estado == PedidoEstado.rechazado
          ).toList();
        } else if (scope == "PRODUCCIÓN") {
          pedidos = pedidos.where((p) =>
            p.estado == PedidoEstado.aprobado ||
            p.estado == PedidoEstado.enPreparacion ||
            p.estado == PedidoEstado.pendiente ||
            p.estado == PedidoEstado.listoEnvio
          ).toList();
        } else if (scope == "DOMICILIO") {
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
    );
  }
}
