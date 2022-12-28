import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/produto.dart';

class EstoqueScreen extends StatefulWidget {
  const EstoqueScreen({super.key});

  @override
  State<EstoqueScreen> createState() => _EstoqueScreenState();
}

class _EstoqueScreenState extends State<EstoqueScreen> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<Produto>> _readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chaves = prefs
        .getKeys()
        .where((element) => element.startsWith('prod_'))
        .toList();
    List<Produto> produtos = [];
    for (var element in chaves) {
      List<String> fragKey = element.split('_');
      Produto prod =
          await Produto(nomeproduto: fragKey[1], volume: fragKey[2]).read();
      produtos.add(prod);
    }
    return produtos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque'),
        actions: [
          IconButton(
            //botão para criar novo produto
            onPressed: () {
              Navigator.of(context).pushNamed('NovoProdutoScreen');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: _searchController,
                      decoration:
                          const InputDecoration(label: Text('Buscar produto')),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.text = '';
                        });
                      },
                      icon: const Icon(Icons.clear)),
                ],
              ),
            ),
            FutureBuilder<List<Produto>>(
                future: _readData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro! não foi possível obter os dados'),
                    );
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<Produto> data = snapshot.data!
                        .where((element) =>
                            "${element.nomeproduto} ${element.volume}"
                                .toLowerCase()
                                .contains(_searchController.text.toLowerCase()))
                        .toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('NovoProdutoScreen',
                                arguments: data[index]);
                          },
                          child: ListTile(
                            hoverColor: Colors.amber,
                            title: Text(
                              '${data[index].nomeproduto} ${data[index].volume}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "R\$ ${data[index].precoVenda.toStringAsFixed(2).replaceAll('.', ',')} (${data[index].quantidade})",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
