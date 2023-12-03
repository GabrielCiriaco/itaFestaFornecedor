// ignore_for_file: unnecessary_this

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:itafestafornecedor/screens/tela_login/login.dart';
import 'package:itafestafornecedor/screens/tela_pedidos/pedidos.dart';
import '../tela_edit_produto/editProduto.dart';
import '../tela_add_produto/addProduto.dart';

import 'package:http/http.dart' as http;

abstract class IFornecedor {
  int get id;
  String get tipo;
  String get nome;
  String get descricao;
  String get endereco;
  String get telefone;
}

class Produto {
  final int id;
  final String nome;
  final String descricao;
  final String valor;
  final String disponivel;
  final int fornecedorId;

  Produto({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.valor,
    required this.disponivel,
    required this.fornecedorId,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      valor: json['valor'],
      disponivel: json['disponivel'],
      fornecedorId: json['fornecedorId'],
    );
  }
}

Future<List<Produto>> fetchProdutos() async {
  final response = await http.get(Uri.parse(
      'https://redes-8ac53ee07f0c.herokuapp.com/api/v1/produtos?fornecedor_id[eq]=1'));

  if (response.statusCode == 200) {
    List<Produto> produtos = [];

    var json = jsonDecode(response.body) as Map<String, dynamic>;

    var data = json['data'] as List<dynamic>;

    for (var produto in data) {
      produtos.add(Produto.fromJson(produto));
    }
    return produtos;
  } else {
    throw Exception('Falha ao carregar produtos');
  }
}

Future<List<Fornecedor>> fetchDadosFornecedor() async {
  final response = await http.get(Uri.parse(
      'https://redes-8ac53ee07f0c.herokuapp.com/api/v1/fornecedores?email[eq]=zé@gmail.com'));

  if (response.statusCode == 200) {
    List<Fornecedor> fornecedores = [];

    var json = jsonDecode(response.body) as Map<String, dynamic>;

    var data = json['data'] as List<dynamic>;

    for (var fornecedor in data) {
      fornecedores.add(Fornecedor.fromJson(fornecedor));
    }
    return fornecedores;
  } else {
    throw Exception('Falha ao carregar produtos');
  }
}

Future<void> removeProduct(int id) async {
  final response = await http.delete(
    Uri.parse('https://redes-8ac53ee07f0c.herokuapp.com/api/v1/produtos/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Falha ao remover produto');
  }
}

class HomePage extends StatefulWidget {
  final Fornecedor fornecedor;

  const HomePage({Key? key, required this.fornecedor}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Produto>> futureProdutos;

  @override
  void initState() {
    super.initState();
    futureProdutos = fetchProdutos();
  }

  void refreshProducts() {
    setState(() {
      futureProdutos = fetchProdutos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Inicio', textAlign: TextAlign.center),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddProductScreen(fornecedor: widget.fornecedor)),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 30,
                  // Substitua o ícone com o ícone desejado para a loja
                  child: Icon(Icons.store, size: 30, color: Colors.white),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fornecedor.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    widget.fornecedor.descricao,
                  ),
                  Text(
                    widget.fornecedor.endereco,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    widget.fornecedor.telefone,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8.0),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 2.0, color: Colors.black),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Produtos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.of(context).size.height - 280,
            child: FutureBuilder(
                future: futureProdutos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: Center(child: CircularProgressIndicator()));
                  }

                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  if (snapshot.hasData) {
                    var produtos = snapshot.data as List<Produto>;
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: produtos.length,
                            itemBuilder: (context, index) {
                              return CardWithProduct(
                                id: produtos[index].id,
                                productName: produtos[index].nome,
                                productDescription: produtos[index].descricao,
                                productPrice: produtos[index].valor,
                                refreshCallback: refreshProducts,
                                fornecedor: widget.fornecedor,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize:
                                  Size(MediaQuery.of(context).size.width, 40)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderScreen(
                                        fornecedor: widget.fornecedor,
                                        produtos: produtos,
                                      )),
                            );
                          },
                          child: const Text('Ver pedidos'),
                        ),
                      ],
                    );
                  }

                  return const SizedBox(height: 20.0, width: 20.0, child: null);
                }),
          ),
        ]),
      ),
    );
  }
}

class CardWithProduct extends StatelessWidget {
  final int id;
  final String productName;
  final String productDescription;
  final String productPrice;
  final VoidCallback? refreshCallback;
  final Fornecedor fornecedor;

  const CardWithProduct({
    super.key,
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    this.refreshCallback,
    required this.fornecedor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              // Substitua o ícone com o ícone desejado para o produto
              child:
                  const Icon(Icons.shopping_bag, size: 40, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    productDescription,
                  ),
                  Text(
                    productPrice,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Remover produto'),
                      content: const Text(
                          'Tem certeza que deseja remover este produto?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await removeProduct(id);
                            if (refreshCallback != null) {
                              refreshCallback!();
                            }
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                          },
                          child: const Text('Remover'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProductScreen(
                            productDescription: this.productDescription,
                            productName: this.productName,
                            productValue: double.parse(this.productPrice),
                            id: this.id,
                            fornecedor: this.fornecedor,
                          )),
                );
              },
              child: const Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
