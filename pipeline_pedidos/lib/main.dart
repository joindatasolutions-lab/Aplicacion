import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Pedidos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mis Pedidos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 1. Aquí declaramos la lista de pedidos.
  // Inicialmente, está vacía.
  final List<String> _pedidos = [];
  int _conteoPedidos = 0;

  // 2. Esta función simulará la llegada de un nuevo pedido.
  void _simularLlegadaPedido() {
    // Usamos setState para que la interfaz sepa que debe redibujarse.
    setState(() {
      _conteoPedidos++;
    });

    // 3. Usamos Future.delayed para esperar 2 segundos.
    // Esto simula el tiempo que tardaría en llegar un pedido real.
    Future.delayed(const Duration(seconds: 2), () {
      // Una vez que el tiempo ha pasado, agregamos el pedido a la lista
      // y volvemos a llamar a setState para que la UI se actualice con el nuevo pedido.
      setState(() {
        _pedidos.add('Pedido #$_conteoPedidos - Llegó a ${DateTime.now().toIso8601String().substring(11, 19)}');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Nuevo pedido recibido!'), duration: Duration(seconds: 1)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _pedidos.isEmpty
            ? const Text('Presiona el botón para simular la llegada de un pedido.')
            : ListView.builder(
                // Construimos la lista de manera eficiente.
                itemCount: _pedidos.length,
                itemBuilder: (context, index) {
                  // Muestra cada elemento de la lista en un widget ListTile.
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(_pedidos[index]),
                      leading: const Icon(Icons.shopping_bag),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _simularLlegadaPedido,
        tooltip: 'Simular pedido',
        child: const Icon(Icons.add),
      ),
    );
  }
}