import 'dart:convert';

import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  bool _showErrorMessage = false;

  void _buscaCep() async {
    String cep = _cepController.text;
    Uri url = Uri.parse("https://viacep.com.br/ws/$cep/json/");
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    http.Response response = await http.get(url, headers: headers);
    Map<String, dynamic> endereco = jsonDecode(response.body);
    setState(() {
      _logradouroController.text = endereco["logradouro"];
      _bairroController.text = endereco["bairro"];
      _cidadeController.text = endereco["localidade"];
      _ufController.text = endereco["uf"];
    });
  }

  void _validaCampo() {
    String? cep = _cepController.text;
    if (cep.isNotEmpty) {
      _buscaCep();
      setState(() {
        _showErrorMessage = false;
      });
    } else {
      setState(() {
        _showErrorMessage = true;
      });
    }
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '#####-###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar endereço pelo CEP"),
        backgroundColor: const Color(0XFFFFD880),
      ),
      body: SafeArea(
        child: Container(
          color: const Color(0xFF44C8F5),
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 35, bottom: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  child:
                      Image.asset("images/logo.png", width: 250, height: 250),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: _showErrorMessage,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.all(
                              Radius.circular(14),
                            ),
                          ),
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                "Preencha o campo CEP!",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        inputFormatters: [maskFormatter],
                        controller: _cepController,
                        decoration: InputDecoration(
                          hintText: "Insira o CEP para buscar",
                          labelText: "CEP",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            _validaCampo();
                          },
                          child: const Text(
                            "Pesquisar CEP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      TextField(
                        readOnly: true,
                        controller: _logradouroController,
                        decoration: InputDecoration(
                          hintText: "Aqui vai aparecer a rua",
                          labelText: "Rua",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      TextField(
                        readOnly: true,
                        controller: _bairroController,
                        decoration: InputDecoration(
                          hintText: "Aqui vai aparecer o bairro",
                          labelText: "Bairro",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      TextField(
                        readOnly: true,
                        controller: _cidadeController,
                        decoration: InputDecoration(
                          hintText: "Aqui vai aparecer a cidade",
                          labelText: "Cidade",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      TextField(
                        readOnly: true,
                        controller: _ufController,
                        decoration: InputDecoration(
                          hintText: "Aqui vai aparecer a UF",
                          labelText: "UF",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Home()),
          );
        },
        backgroundColor: const Color(0xFFF27DAD),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
