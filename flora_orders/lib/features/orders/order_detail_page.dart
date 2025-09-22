import 'package:flutter/material.dart';
import '../../theme.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.order});
  final Map<String, String> order;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late String _estado;
  String? _cuenta;
  final List<String> _cuentasMock = [
    "Nequi 3xx xxx xxx",
    "Bancolombia Ahorros ****1234",
    "Daviplata ***5678"
  ];

  @override
  void initState() {
    super.initState();
    _estado = widget.order["Estado"] ?? "Pendiente";
  }

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
    return Scaffold(
      appBar: AppBar(title: Text("Pedido ${o["Pedido"]}")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Tile(label: "Cliente", value: o["Cliente"] ?? ""),
            _Tile(label: "Producto", value: o["Producto"] ?? ""),
            _Tile(label: "Fecha", value: o["Fecha"] ?? ""),
            _Tile(label: "Fecha de Entrega", value: o["Fecha de Entrega"] ?? ""),
            _Tile(label: "Forma de Pago", value: o["FormaPago"] ?? "Transferencia"),
            _Tile(label: "Total", value: "\$${o["Total"] ?? "0"}"),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text("Cambiar estado", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text("Pendiente"),
                  selected: _estado == "Pendiente",
                  onSelected: (_) => setState(() => _estado = "Pendiente"),
                ),
                ChoiceChip(
                  label: const Text("Aprobado"),
                  selected: _estado == "Aprobado",
                  onSelected: (_) => setState(() => _estado = "Aprobado"),
                ),
                ChoiceChip(
                  label: const Text("No Aprobado"),
                  selected: _estado == "No Aprobado",
                  onSelected: (_) => setState(() => _estado = "No Aprobado"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_estado == "Aprobado") ...[
              Text("Cuenta bancaria", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _cuenta,
                items: _cuentasMock
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _cuenta = v),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: kFloraSage),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: kFloraSage),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Regresar"),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_estado == "Aprobado" && _cuenta == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Selecciona la cuenta bancaria")),
                      );
                      return;
                    }
                    // Aquí luego llamas a la API PATCH /orders/{id}/status
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Estado actualizado a $_estado")),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Guardar cambios"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.value});
  final String label, value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(
                color: kFloraTaupe,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
