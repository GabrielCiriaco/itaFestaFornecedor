import 'dart:convert';

import 'package:flutter/material.dart';
import '../tela_inicial/home.dart';

import 'package:http/http.dart' as http;

class Fornecedor {
  final int id;
  final String nome;
  final String email;
  final String senha;
  final String descricao;
  final String endereco;
  final String telefone;

  Fornecedor(
      {required this.id,
      required this.nome,
      required this.email,
      required this.senha,
      required this.descricao,
      required this.endereco,
      required this.telefone});

  factory Fornecedor.fromJson(Map<String, dynamic> json) {
    return Fornecedor(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      descricao: json['descricao'],
      endereco: json['endereco'],
      telefone: json['telefone'],
    );
  }
}

Future<Fornecedor> attemptLogin(String email) async {
  try {
    final response = await http.get(Uri.parse(
        'https://redes-8ac53ee07f0c.herokuapp.com/api/v1/fornecedores?email[eq]=$email'));

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body) as Map<String, dynamic>;

      var fornecedor = json['data'][0];

      return Fornecedor.fromJson(fornecedor);
    }

    return Fornecedor(
        id: 0,
        nome: '',
        email: '',
        senha: '',
        descricao: '',
        endereco: '',
        telefone: '');
  } catch (err) {
    return Fornecedor(
        id: -1,
        nome: '',
        email: '',
        senha: '',
        descricao: '',
        endereco: '',
        telefone: '');
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final loading = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Image(
                image: AssetImage('lib/assets/logo.png'),
                height: 250,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true, // Para ocultar a senha
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    String enteredEmail = emailController.text;
                    String enteredPassword = passwordController.text;

                    loading.value = true;
                    var fornecedor = await attemptLogin(enteredEmail);
                    loading.value = false;

                    if (enteredEmail == fornecedor.email &&
                        enteredPassword == fornecedor.senha) {
                      if (!mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage(fornecedor: fornecedor)),
                      );
                    } else {
                      if (!mounted) return;
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Erro de Login'),
                          content: fornecedor.id == -1
                              ? Text('Erro de rede')
                              : Text('Credenciais inválidas. Tente novamente.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: AnimatedBuilder(
                    animation: loading,
                    builder: (context, child) {
                      if (loading.value) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const Text('Entrar');
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
