import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  final String productName;
  final String productDescription;
  final double productValue;
  final int supplierId;

  const EditProductScreen({
    required this.productName,
    required this.productDescription,
    required this.productValue,
    required this.supplierId,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Editar', textAlign: TextAlign.center),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Retorna para a tela anterior
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: EditProductForm(
            initialProductName: productName,
            initialProductDescription: productDescription,
            initialProductValue: productValue.toString(),
            initialSupplierId: supplierId.toString(),
          ),
        ),
      ),
    );
  }
}

class EditProductForm extends StatefulWidget {
  final String initialProductName;
  final String initialProductDescription;
  final String initialProductValue;
  final String initialSupplierId;

  const EditProductForm({
    required this.initialProductName,
    required this.initialProductDescription,
    required this.initialProductValue,
    required this.initialSupplierId,
  });

  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;
  late TextEditingController _supplierIdController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProductName);
    _descriptionController =
        TextEditingController(text: widget.initialProductDescription);
    _valueController = TextEditingController(text: widget.initialProductValue);
    _supplierIdController =
        TextEditingController(text: widget.initialSupplierId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    _supplierIdController.dispose();
    super.dispose();
  }

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
            // Adicione a lógica para atualizar o produto com os novos valores
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
          child: Text('Salvar Alterações'),
        ),
      ],
    );
  }
}



