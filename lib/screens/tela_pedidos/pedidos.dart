import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pedidos', textAlign: TextAlign.center),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Retorna para a tela anterior
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
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
  @override
  _OrderCardState createState() => _OrderCardState();
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
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.shopping_bag), // Ícone referente ao produto
        title: Text('Nome do Produto'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome do Cliente'),
            Text('Endereço de Entrega'),
            Text('Valor Total'),
          ],
        ),
        trailing: IconButton(
          icon: isConfirmed ? Icon(Icons.done) : Icon(Icons.delivery_dining),
          onPressed: () {
            toggleConfirmation();
          },
        ),
      ),
    );
  }
}
