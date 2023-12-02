import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itafestafornecedor/screens/tela_inicial/home.dart';
import 'package:http/http.dart' as http;
import 'package:itafestafornecedor/screens/tela_login/login.dart';

class EditProductScreen extends StatelessWidget {
  final int id;
  final String productName;
  final String productDescription;
  final double productValue;
  final Fornecedor fornecedor;

  const EditProductScreen({
    super.key,
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productValue,
    required this.fornecedor,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Editar', textAlign: TextAlign.center),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Retorna para a tela anterior
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: EditProductForm(
            initialProductName: productName,
            initialProductDescription: productDescription,
            initialProductValue: productValue.toString(),
            productId: id,
            fornecedor: fornecedor,
          ),
        ),
      ),
    );
  }
}

Future<void> editProduct(
    BuildContext context, Produto produto, Fornecedor fornecedor) async {
  var response = await http.put(
    Uri.parse(
        'https://redes-8ac53ee07f0c.herokuapp.com/api/v1/produtos/${produto.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'nome': produto.nome,
      'descricao': produto.descricao,
      'valor': produto.valor,
      'disponivel': true,
      'fornecedor_id': 1,
    }),
  );

  if (response.statusCode == 200) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Produto editado com sucesso!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o alerta
              // volta para home
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomePage(fornecedor: fornecedor),
                ),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  } else {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro ao editar produto!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o alerta
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class EditProductForm extends StatefulWidget {
  final int productId;
  final String initialProductName;
  final String initialProductDescription;
  final String initialProductValue;
  final Fornecedor fornecedor;

  const EditProductForm({
    super.key,
    required this.productId,
    required this.initialProductName,
    required this.initialProductDescription,
    required this.initialProductValue,
    required this.fornecedor,
  });

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;

  final loading = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProductName);
    _descriptionController =
        TextEditingController(text: widget.initialProductDescription);
    _valueController = TextEditingController(text: widget.initialProductValue);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(labelText: 'Nome do Produto'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Descrição'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _valueController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Valor (Ex: 25.50)'),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            loading.value = true;
            Produto produto = Produto(
              id: widget.productId,
              nome: _nameController.text,
              descricao: _descriptionController.text,
              valor: _valueController.text,
              disponivel: 'true',
              fornecedorId: widget.fornecedor.id,
            );

            editProduct(context, produto, widget.fornecedor).then((value) => {
                  loading.value = false,
                });
          },
          child: AnimatedBuilder(
            animation: loading,
            builder: (context, child) {
              return loading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Editar');
            },
          ),
        ),
      ],
    );
  }
}
