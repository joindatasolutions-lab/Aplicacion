// lib/presentation/screens/pipeline_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import '../../data/models/order_model.dart';
import '../../data/providers/order_provider.dart';
import '../widgets/order_card_widget.dart';

class PipelineScreen extends StatefulWidget {
  const PipelineScreen({Key? key}) : super(key: key);

  @override
  State<PipelineScreen> createState() => _PipelineScreenState();
}

class _PipelineScreenState extends State<PipelineScreen> {
  late List<DragAndDropList> _contents;

  @override
  void initState() {
    super.initState();
    // Cargar los datos cuando la pantalla se inicie
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("Seguimiento de Pedidos"),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1E1E1E),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color(0xFF0078D4)),
            onPressed: () { /* Lógica para nuevo pedido */ },
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }

          _buildLists(provider); // Construir las listas con datos frescos

          return DragAndDropLists(
            children: _contents,
            onItemReorder: _onItemReorder,
            onListReorder: (int oldIndex, int newIndex) {}, // No necesitamos reordenar columnas
            axis: Axis.horizontal,
            listWidth: 300,
            listDraggingWidth: 300,
            listPadding: const EdgeInsets.all(8.0),
            listDecoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            itemDecorationWhileDragging: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
            ),
          );
        },
      ),
    );
  }

  void _buildLists(OrderProvider provider) {
    _contents = [
      _buildColumn("PEDIDOS", provider.pedidos),
      _buildColumn("PRODUCCIÓN", provider.produccion),
      _buildColumn("DOMICILIO", provider.domicilio),
    ];
  }

  DragAndDropList _buildColumn(String title, List<Order> orders) {
    return DragAndDropList(
      header: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF666666)),
        ),
      ),
      children: orders.map((order) => DragAndDropItem(
        child: OrderCardWidget(order: order),
        // Guardamos el ID del pedido para saber cuál se está moviendo
        feedbackWhileDragging: SizedBox(width: 280, child: OrderCardWidget(order: order)),
      )).toList(),
    );
  }

  void _onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    if (oldListIndex == newListIndex) return; // No hacer nada si se mueve en la misma columna
    
    final provider = Provider.of<OrderProvider>(context, listen: false);
    final movedOrderId = _contents[oldListIndex].children[oldItemIndex].key.toString();
    
    // Extraer el ID real del widget OrderCardWidget
    final order = (provider.pedidos + provider.produccion + provider.domicilio)
      .firstWhere((o) => o.id == ( (_contents[oldListIndex].children[oldItemIndex] as DragAndDropItem).child as OrderCardWidget).order.id);

    OrderPhase targetPhase;
    switch(newListIndex) {
      case 0: targetPhase = OrderPhase.pedidos; break;
      case 1: targetPhase = OrderPhase.produccion; break;
      case 2: targetPhase = OrderPhase.domicilio; break;
      default: return;
    }

    provider.moveOrder(order.id, targetPhase);
  }
}