import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/militar.dart';

class MilitaresScreen extends StatefulWidget {
  const MilitaresScreen({super.key});

  @override
  State<MilitaresScreen> createState() => _MilitaresScreenState();
}

class _MilitaresScreenState extends State<MilitaresScreen> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<Militar>> _readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chaves =
        prefs.getKeys().where((element) => element.startsWith('mil_')).toList();
    List<Militar> militares = [];
    for (var element in chaves) {
      List<String> fragKey = element.split('_');
      Militar mil =
          await Militar(postoGrad: fragKey[1], nomeGuerra: fragKey[2]).read();
      militares.add(mil);
    }
    return militares;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Militares'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('NovoMilitarScreen');
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
                          const InputDecoration(label: Text('Buscar militar')),
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
            FutureBuilder<List<Militar>>(
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
                    List<Militar> data = snapshot.data!
                        .where((element) =>
                            "${element.postoGrad} ${element.nomeGuerra}"
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
                            Navigator.of(context).pushNamed('NovoMilitarScreen',
                                arguments: data[index]);
                          },
                          child: ListTile(
                            hoverColor: Colors.amber,
                            title: Text(
                              '${data[index].postoGrad} ${data[index].nomeGuerra}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              "${data[index].isSocio ? 'Sócio' : 'Não sócio'}${data[index].isFuncionario ? ' e funcionário' : ''}",
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
