// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:itafestafornecedor/screens/tela_pedidos/pedidos.dart';
import '../tela_edit_produto/editProduto.dart';
import '../tela_add_produto/addProduto.dart';


abstract class IFornecedor {
  int get id;
  String get tipo;
  String get nome;
  String get descricao;
  String get endereco;
  String get telefone;
}

class HomePage extends StatelessWidget {

 final List <Map<String, dynamic>>fornecedores = [
    {
      'id': 1,
      'tipo': 'bolos',
      'nome': 'João Bolos',
      'descricao': 'Os melhores bolos doces de Itajubá',
      'endereco': 'Rua dos Bolos, 123',
      'telefone': '123456789'
    },
    {
      'id': 2,
      'tipo': 'salgados',
      'nome': 'Maria Salgados',
      'descricao': 'Os melhores salgados de Itajubá',
      'endereco': 'Rua dos Salgados, 123',
      'telefone': '123456789'
    },
    {
      'id': 3,
      'tipo': 'doces',
      'nome': 'José Doces',
      'descricao': 'Os melhores doces de Itajubá',
      'endereco': 'Rua dos Doces, 123',
      'telefone': '123456789'
    },
    {
      'id': 4,
      'tipo': 'bebidas',
      'nome': 'Joana Bebidas',
      'descricao': 'As melhores bebidas de Itajubá',
      'endereco': 'Rua das Bebidas, 123',
      'telefone': '123456789'
    },
    // Adicione outros fornecedores aqui
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Inicio', textAlign: TextAlign.center),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                 Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddProductScreen()),
                    );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Padding(
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
                        'Nome da Loja',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'Descrição da loja de exemplo',
                      ),
                      Text(
                        'Endereço: Rua Exemplo, 123',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        'Telefone: (00) 1234-5678',
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: 8.0),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 2.0, color: Colors.black),
                        ),
                      ),
                      child: Padding(
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
              SizedBox(height: 10),
              CardWithProduct(
                productName: 'Produto A',
                productDescription: 'Descrição do Produto A',
                productPrice: 'R\$ 25,00',
              ),
              CardWithProduct(
                productName: 'Produto B',
                productDescription: 'Descrição do Produto B',
                productPrice: 'R\$ 35,00',
              ),
              CardWithProduct(
                productName: 'Produto C',
                productDescription: 'Descrição do Produto C',
                productPrice: 'R\$ 15,00',
              ),
               const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderScreen()),
                    );
              },
              child: const Text('Ver pedidos'),
            ),
            ],
          ),
        ),
      );
  }
}

class CardWithProduct extends StatelessWidget {
  final String productName;
  final String productDescription;
  final String productPrice;

  const CardWithProduct({
    required this.productName,
    required this.productDescription,
    required this.productPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              // Substitua o ícone com o ícone desejado para o produto
              child: Icon(Icons.shopping_bag, size: 40, color: Colors.white),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    productDescription,
                  ),
                  Text(
                    productPrice,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Excluir");
              },
              child: Icon(Icons.delete, color: Colors.red),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProductScreen( 
                        productDescription: this.productName,
                        productName: this.productDescription,
                        productValue: 25,
                        supplierId: 1,
                      )),
                    );
              },
              child: Icon(Icons.edit),
            ),
           
          ],
        ),
      ),
    );
  }
}