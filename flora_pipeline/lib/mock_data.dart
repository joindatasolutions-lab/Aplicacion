import 'models/pedido.dart';

final List<Pedido> mockPedidos = [
  Pedido(
    id: "001",
    cliente: "Juan Pérez",
    fecha: DateTime.now(),
    fase: PedidoFase.pedidos,
    estado: PedidoEstado.pendiente,
    resumen: "1 artículo: Pizza Hawaiana",
    total: 35000,
  ),
  Pedido(
    id: "002",
    cliente: "Ana Gómez",
    fecha: DateTime.now(),
    fase: PedidoFase.pedidos,
    estado: PedidoEstado.aprobado,
    resumen: "2 artículos: Pizza Vegetariana",
    total: 60000,
  ),
  Pedido(
    id: "003",
    cliente: "Carlos Ruiz",
    fecha: DateTime.now(),
    fase: PedidoFase.produccion,
    estado: PedidoEstado.enPreparacion,
    resumen: "3 artículos: Pizza Pepperoni",
    total: 90000,
  ),
  Pedido(
    id: "004",
    cliente: "Laura Díaz",
    fecha: DateTime.now(),
    fase: PedidoFase.domicilio,
    estado: PedidoEstado.enCamino,
    resumen: "1 artículo: Pizza Mexicana",
    total: 40000,
  ),
];
