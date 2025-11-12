import 'package:flutter/material.dart';
import '../models/pedido.dart';
import '../services/pedido_service.dart';
import '../widgets/pedido_card.dart';
import '../theme.dart';

class PipelineScreen extends StatefulWidget {
  const PipelineScreen({super.key});

  @override
  State<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends State<PipelineScreen> {
  late Future<List<Pedido>> futurePedidos;
  late Future<List<Pedido>> futureProduccion;
  late Future<List<Pedido>> futureDomicilios;
  late Future<List<Pedido>> futureTerminados;
  late Future<List<Pedido>> futureEntregados;


  String searchQuery = "";
  PedidoEstado? filtroEstado;

  @override
  void initState() {
    super.initState();
    futurePedidos = PedidoService.getPedidos();
    futureProduccion = PedidoService.getProduccion();
    futureTerminados = PedidoService.getTerminados();
    futureDomicilios = PedidoService.getDomicilios();
    futureEntregados = PedidoService.getEntregados();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(180),
        child: AppBar(
          backgroundColor: const Color(0xFFFFFCFB),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 6.0),
                  child: Image.asset(
                    'assets/images/logo_flora.png',
                    height: 90,
                    fit: BoxFit.contain,
                  ),
                ),
                const Text(
                  "Pipeline de Pedidos",
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFC98989),
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),

      // ---------------- BODY PRINCIPAL ----------------
      body: Column(
        children: [
          // 🔍 Buscador
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Color(0xFFC98989)),
                hintText: "Buscar por cliente, producto o ID...",
                hintStyle: const TextStyle(color: Color(0xFFB99E9E)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, // 💅 sin borde

                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFFC98989), width: 2),
                ),
              ),
              onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
            ),
          ),
          Expanded(child: isMobile ? _buildMobileView() : _buildDesktopView()),
        ],
      ),
    );
  }

  // ------------------ 📱 VISTA MÓVIL ------------------
  Widget _buildMobileView() {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
          const TabBar(
            labelColor: Color(0xFFC98989),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFC98989),
            tabs: [
              Tab(text: "PEDIDOS"),
              Tab(text: "PRODUCCIÓN"),
              Tab(text: "TERMINADOS"),
              Tab(text: "DOMICILIO"),
              Tab(text: "ENTREGADOS"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _columnBody(futurePedidos, scope: "PEDIDOS"),
                _columnBody(futureProduccion, scope: "PRODUCCIÓN"),
                _columnBody(futureTerminados, scope: "TERMINADOS"),
                _columnBody(futureDomicilios, scope: "DOMICILIO"),
                _columnBody(futureEntregados, scope: "ENTREGADOS"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ 💻 VISTA ESCRITORIO ------------------
  Widget _buildDesktopView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _desktopColumn("PEDIDOS", futurePedidos),
            _desktopColumn("PRODUCCIÓN", futureProduccion),
            _desktopColumn("TERMINADOS", futureTerminados),
            _desktopColumn("DOMICILIO", futureDomicilios),
            _desktopColumn("ENTREGADOS", futureEntregados),
          ],
        );
      },
    );
  }

  Widget _desktopColumn(String title, Future<List<Pedido>> future) {
    return Expanded(
      child: Column(
        children: [
          _columnHeader(title),
          Expanded(child: _columnBody(future, scope: title)),
        ],
      ),
    );
  }

  Widget _columnHeader(String titulo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade100,
      child: Text(
        titulo,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Color(0xFF444444),
        ),
      ),
    );
  }

  // ------------------ CONTENIDO (móvil y escritorio) ------------------
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

        // 🔍 Filtro búsqueda
        if (searchQuery.isNotEmpty) {
          final q = searchQuery;
          pedidos = pedidos
              .where((p) =>
                  p.cliente.toLowerCase().contains(q) ||
                  p.resumen.toLowerCase().contains(q) ||
                  p.id.toLowerCase().contains(q))
              .toList();
        }

        // 🎚 Filtro por estado manual (si se usa)
        if (filtroEstado != null) {
          pedidos = pedidos.where((p) => p.estado == filtroEstado).toList();
        }

        // ---------------- FILTRADO LÓGICO POR PIPELINE ----------------
      
       switch (scope) {
          case "PEDIDOS":
            print("🧾 Filtrando pedidos...");
            pedidos = pedidos.where((p) =>
                p.estado == PedidoEstado.pendiente ||
                p.estado == PedidoEstado.rechazado).toList();
                //|| p.estado == PedidoEstado.aprobado).toList();
            break;
          case "PRODUCCION":
            print("⚙️ Filtrando producción...");
            pedidos = pedidos.where((p) =>
                p.estado == PedidoEstado.enPreparacion ||
                p.estado == PedidoEstado.pendiente).toList();
            break;

          case "TERMINADOS":
            print("✅ Filtrando terminados y por recoger...");
            pedidos = pedidos.where((p) =>
                p.estado == PedidoEstado.finalizado ||
                p.estado == PedidoEstado.listoEnvio).toList();
            break;

          case "DOMICILIO":
            print("🧭 Filtrando domicilios activos...");
            for (var p in pedidos) {
              print("🏷️ Pedido ${p.id} con estado ${p.estado}");
            }

            pedidos = pedidos.where((p) {
              return p.estado == PedidoEstado.enCamino ||
                     p.estado == PedidoEstado.incidencia;
            }).toList();
            break;



          case "ENTREGADOS":
            print("Filtrando entregados...");
            pedidos = pedidos
                .where((p) => p.estado == PedidoEstado.entregado)
                .toList();
            break;
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
