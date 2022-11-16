// ignore_for_file: prefer_const_constructors, dead_code, body_might_complete_normally_nullable, unused_local_variable

import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:atak_sistemas_teste/models/pesquisa.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late Future<Pesquisa> pesquisa;
  List<Pesquisa> pesquisa = [];
  bool isLoading = false;
  Pesquisa pesquisado = Pesquisa(title: '', url: '');
  @override
  void initState() {
    super.initState();
    getData('maringa');
  }

  Future<List<Pesquisa>> getData(String nome) async {
    setState(() {
      isLoading = true;
    });
    try {
      final uri = Uri.parse('http://localhost:3000/search?searchquery=$nome');
      final response = await http.get(uri);
      switch (response.statusCode) {
        case 200:
          Iterable l = json.decode(response.body);
          List<Pesquisa> aux =
              List<Pesquisa>.from(l.map((e) => Pesquisa.fromJson(e)));
          pesquisa = aux;
          setState(() {
            isLoading = false;
          });
          return pesquisa;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> itens = [];
    TextEditingController _textEditingController = TextEditingController();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade700,
          title: const Center(child: Text("Atak Sistemas Teste")),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.orange.shade200,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 45,
                          width: 300,
                          child: Card(
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: TextFormField(
                              controller: _textEditingController,
                              cursorColor: Colors.orange.shade200,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              decoration: InputDecoration(
                                floatingLabelStyle:
                                    TextStyle(color: Colors.grey.shade600),
                                focusColor: Colors.orange.shade200,
                                border: InputBorder.none,
                                labelText: 'Buscar no Google',
                                labelStyle: TextStyle(fontSize: 16),
                                contentPadding: EdgeInsets.only(
                                    left: 15, top: 0, bottom: 17),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  color: Colors.grey,
                                  onPressed: () {
                                    getData(_textEditingController.text);
                                    setState(() {});
                                  },
                                ),
                                suffixIconColor: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Resultados de busca:",
                            style: TextStyle(fontSize: 35),
                          ),
                        ),
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView(
                                        children: [
                                          for (var item in pesquisa)
                                            Column(
                                              children: [
                                                Text(item.title),
                                                InkWell(
                                                  child: Text(item.url),
                                                  onTap: () async {
                                                    final url =
                                                        Uri.parse(item.url);
                                                    if (await canLaunchUrl(
                                                        url)) {
                                                      await launchUrl(url);
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                )
                                              ],
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
