import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
       appBar: AppBar(
          title: Text('Adicionar', textAlign: TextAlign.center),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Retorna para a tela anterior
            },
          ),
       ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: AddProductForm(),
        ),
      ),
    );
  }
}

class AddProductForm extends StatefulWidget {
  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _supplierIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Nome do Produto'),
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(labelText: 'Descrição'),
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: _valueController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: 'Valor (Ex: 25.50)'),
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: _supplierIdController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'ID do Fornecedor'),
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            // Adicionar lógica para processar os dados inseridos
            final String productName = _nameController.text;
            final String productDescription = _descriptionController.text;
            final double productValue = double.parse(_valueController.text);
            final int supplierId = int.parse(_supplierIdController.text);

            // Imprimir os valores para verificar se estão corretos
            print('Nome: $productName');
            print('Descrição: $productDescription');
            print('Valor: $productValue');
            print('ID do Fornecedor: $supplierId');
          },
          child: Text('Adicionar Produto'),
        ),
      ],
    );
  }
}


