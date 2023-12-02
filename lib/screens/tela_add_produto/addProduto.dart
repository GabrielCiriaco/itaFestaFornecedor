import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itafestafornecedor/screens/tela_inicial/home.dart';
import 'package:itafestafornecedor/screens/tela_login/login.dart';

class AddProductScreen extends StatelessWidget {
  final Fornecedor fornecedor;

  const AddProductScreen({super.key, required this.fornecedor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Adicionar', textAlign: TextAlign.center),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Retorna para a tela anterior
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AddProductForm(fornecedor: fornecedor),
        ),
      ),
    );
  }
}

Future<void> addProduct(
    BuildContext context, Produto produto, Fornecedor fornecedor) async {
  var response = await http.post(
    Uri.parse('https://redes-8ac53ee07f0c.herokuapp.com/api/v1/produtos'),
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

  if (response.statusCode == 201) {
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Produto adicionado com sucesso!'),
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
            child: const Text('Voltar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fecha o alerta
            },
            child: const Text('Adicionar mais'),
          ),
        ],
      ),
    );
  } else {
    print(response.statusCode);
  }
}

class AddProductForm extends StatefulWidget {
  final Fornecedor fornecedor;

  const AddProductForm({Key? key, required this.fornecedor}) : super(key: key);

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  final loading = ValueNotifier(false);

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
              id: 0,
              nome: _nameController.text,
              descricao: _descriptionController.text,
              valor: _valueController.text,
              disponivel: 'true',
              fornecedorId: widget.fornecedor.id,
            );

            addProduct(context, produto, widget.fornecedor).then((value) => {
                  loading.value = false,
                  _nameController.clear(),
                  _descriptionController.clear(),
                  _valueController.clear(),
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
                  : const Text('Adicionar produto');
            },
          ),
        )
      ],
    );
  }
}
