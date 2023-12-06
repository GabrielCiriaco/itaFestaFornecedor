import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:itafestafornecedor/screens/tela_inicial/home.dart';
import 'package:itafestafornecedor/screens/tela_login/login.dart';

class Cliente {
  final int id;
  final String nome;
  final String endereco;

  Cliente({
    required this.id,
    required this.nome,
    required this.endereco,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      endereco: json['endereco'],
    );
  }
}

class Pedido {
  final int id;
  final String quantidade;
  final String data;
  final String retirada;
  final String valorTotal;
  final Cliente cliente;
  final int produtoId;
  String? produtoNome;

  Pedido(
      {required this.id,
      required this.quantidade,
      required this.data,
      required this.retirada,
      required this.valorTotal,
      required this.cliente,
      required this.produtoId,
      this.produtoNome});

  set setProdutoNome(String nome) {
    produtoNome = nome;
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
        id: json['id'],
        quantidade: json['quantidade'],
        data: json['data'],
        retirada: json['retirada'],
        valorTotal: json['valor_total'],
        cliente: Cliente.fromJson(json['cliente']),
        produtoId: json['produto_id']);
  }
}

Future<List<Pedido>> fetchPedidos(
    Fornecedor fornecedor, List<Produto> produtos) async {
  final response = await http.get(
    Uri.parse(
        'https://redes-8ac53ee07f0c.herokuapp.com/api/v1/pedidos?fornecedor_id[eq]=${fornecedor.id}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    List<Pedido> pedidos = [];

    var json = jsonDecode(response.body) as Map<String, dynamic>;

    var data = json['data'] as List<dynamic>;

    for (var pedido in data) {
      var instancia = Pedido.fromJson(pedido);

      for (var produto in produtos) {
        if (instancia.produtoId == produto.id) {
          instancia.produtoNome = produto.nome;
        }
      }

      instancia.produtoNome ??= 'Produto não encontrado';

      pedidos.add(instancia);
    }

    return pedidos;
  } else {
    throw Exception('Falha ao carregar os pedidos');
  }
}

class OrderScreen extends StatefulWidget {
  final Fornecedor fornecedor;
  final List<Produto> produtos;

  const OrderScreen(
      {super.key, required this.fornecedor, required this.produtos});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future<List<Pedido>> futurePedidos;

  @override
  void initState() {
    super.initState();
    futurePedidos = fetchPedidos(widget.fornecedor, widget.produtos);
  }

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
            child: FutureBuilder(
              future: futurePedidos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ));
                }

                if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                if (snapshot.hasData) {
                  var pedidos = snapshot.data as List<Pedido>;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pedidos.length,
                    physics:
                        const AlwaysScrollableScrollPhysics(), // Substitua pelo número de pedidos
                    itemBuilder: (context, index) {
                      return OrderCard(pedido: pedidos[index]);
                    },
                  );
                }

                return const SizedBox(height: 20.0, width: 20.0, child: null);
              },
            )),
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  // final Fornecedor fornecedor;
  final Pedido pedido;

  const OrderCard({super.key, required this.pedido});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isConfirmed = true;

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
        title: Text(widget.pedido.produtoNome!),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.pedido.cliente.nome),
            Text(widget.pedido.cliente.endereco),
            Text(widget.pedido.valorTotal),
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
