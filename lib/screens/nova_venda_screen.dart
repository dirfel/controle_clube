import 'package:controle_clube/models/carrinho.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/militar.dart';
import '../models/produto.dart';

class NovaVendaScreen extends StatefulWidget {
  const NovaVendaScreen({super.key});

  @override
  State<NovaVendaScreen> createState() => _NovaVendaScreenState();
}

class _NovaVendaScreenState extends State<NovaVendaScreen> {
  late Militar args;
  bool estadoCriado = false;
  final TextEditingController _searchController = TextEditingController();
  late Carrinho carrinho;

  Future<List<Produto>> _readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chaves = prefs.getKeys().where((element) => element.startsWith('prod_')).toList();
    List<Produto> produtos = [];
    for (var element in chaves) {
      List<String> fragKey = element.split('_');
      Produto prod = await Produto(nomeproduto: fragKey[1], volume: fragKey[2]).read();
      if (prod.quantidade > 0) {
        produtos.add(prod);
      }
    }
    return produtos;
  }

  @override
  Widget build(BuildContext context) {
    if (!estadoCriado) {
      args = ModalRoute.of(context)!.settings.arguments as Militar? ?? Militar();
      carrinho = Carrinho(militar: args.dbKey, produtos: []);
    }
    estadoCriado = true;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Venda'),
        actions: [
          IconButton(
            //botão para criar novo produto
            onPressed: () {
              Navigator.of(context).pushNamed('FinalizarCompraScreen', arguments: carrinho);
            },
            icon: carrinho.isEmpty ? const Icon(Icons.shopping_cart_outlined) : const Icon(Icons.shopping_cart_rounded),
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
                      decoration: const InputDecoration(label: Text('Buscar produto')),
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
                        .where((element) => "${element.nomeproduto} ${element.volume}"
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
                            int indCarrinho = carrinho.produtos.indexWhere((element) =>
                                (element.nomeproduto == data[index].nomeproduto && element.volume == data[index].volume));
                            final formKey = GlobalKey<FormState>();
                            TextEditingController quantidadeController = TextEditingController(
                                text: indCarrinho != -1 ? carrinho.produtos[indCarrinho].quantidade.toString() : '1');
                            TextEditingController precoController = TextEditingController(
                                text: indCarrinho != -1
                                    ? carrinho.produtos[indCarrinho].precoVenda.toStringAsFixed(2).replaceAll('.', ',')
                                    : data[index].precoVenda.toStringAsFixed(2).replaceAll('.', ','));
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  height: 200,
                                  child: Scaffold(
                                    appBar: AppBar(
                                      title: Text('${data[index].nomeproduto} ${data[index].volume}'),
                                    ),
                                    body: Form(
                                      key: formKey,
                                      autovalidateMode: AutovalidateMode.always,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                validator: (value) {
                                                  int? quant = int.tryParse(value!);
                                                  if (quant == null || quant < 0) {
                                                    return 'Quantidade Inválida';
                                                  } else if (quant > data[index].quantidade) {
                                                    return 'Não há tantos do produto.';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                keyboardType:
                                                    const TextInputType.numberWithOptions(decimal: false, signed: false),
                                                decoration: const InputDecoration(
                                                  label: Text('Quantidade'),
                                                ),
                                                controller: quantidadeController,
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextFormField(
                                                onChanged: (value) {
                                                  setState(() {});
                                                },
                                                controller: precoController,
                                                validator: (value) {
                                                  double? preco = double.tryParse(value!.replaceAll(',', '.'));
                                                  if (preco == null || preco <= 0) {
                                                    return 'Preço Inválido!';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                                                decoration: const InputDecoration(
                                                  label: Text('Preço de venda'),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                onPressed: formKey.currentState != null
                                                    // (int.tryParse(value!) == null || int.tryParse(value!) < 0 || int.tryParse(value!) > data[index].quantidade)
                                                    ? null
                                                    : () {
                                                        if (indCarrinho == -1) {
                                                          // nesse caso crio item no carrinho
                                                          carrinho.adicionarProdutoCarrinho(Produto(
                                                            nomeproduto: data[index].nomeproduto,
                                                            volume: data[index].volume,
                                                            quantidade: int.tryParse(quantidadeController.text) ?? 1,
                                                            precoVenda:
                                                                double.tryParse(precoController.text.replaceAll(',', '.')) ??
                                                                    data[index].precoVenda,
                                                          ));
                                                        } else if (quantidadeController.text == '0') {
                                                          // deletar
                                                          carrinho.deletarProdutoCarrinho(Produto(
                                                            nomeproduto: data[index].nomeproduto,
                                                            volume: data[index].volume,
                                                          ));
                                                        } else {
                                                          // atualizar
                                                          carrinho.atualizarProdutoCarrinho(
                                                              Produto(
                                                                nomeproduto: data[index].nomeproduto,
                                                                volume: data[index].volume,
                                                              ),
                                                              double.tryParse(precoController.text.replaceAll(',', '.')) ?? 1,
                                                              int.tryParse(quantidadeController.text) ?? 0);
                                                        }
                                                        setState(() {});
                                                        Navigator.of(context).pop();
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('Carrinho atualizado'),
                                                          ),
                                                        );
                                                        setState(() {});
                                                      },
                                                child: Text(
                                                  indCarrinho != -1 ? 'Editar\ncarrinho' : 'Adicionar \nao carrinho',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
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
