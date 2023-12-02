import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pedidos', textAlign: TextAlign.center),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Retorna para a tela anterior
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: 5, // Substitua pelo número de pedidos
            itemBuilder: (context, index) {
              return OrderCard();
            },
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  const OrderCard({super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isConfirmed = false;

  void toggleConfirmation() {
    setState(() {
      isConfirmed = !isConfirmed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.shopping_bag), // Ícone referente ao produto
        title: const Text('Nome do Produto'),
        subtitle: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome do Cliente'),
            Text('Endereço de Entrega'),
            Text('Valor Total'),
          ],
        ),
        trailing: IconButton(
          icon: isConfirmed
              ? const Icon(Icons.done)
              : const Icon(Icons.delivery_dining),
          onPressed: () {
            toggleConfirmation();
          },
        ),
      ),
    );
  }
}
