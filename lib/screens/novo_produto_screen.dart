// ignore_for_file: use_build_context_synchronously

import 'package:controle_clube/models/produto.dart';
import 'package:flutter/material.dart';

class NovoProdutoScreen extends StatefulWidget {
  const NovoProdutoScreen({super.key});

  @override
  State<NovoProdutoScreen> createState() => _NovoProdutoScreenState();
}

class _NovoProdutoScreenState extends State<NovoProdutoScreen> {
  bool estadoCriado = false;
  final TextEditingController _nomeProdutoController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _precoVendaController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();

  late Produto args;
  late bool isNew;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (!estadoCriado) {
      args = ModalRoute.of(context)!.settings.arguments as Produto? ?? Produto();
      isNew = args.toJson() == Produto().toJson();

      if (!isNew) {
        _nomeProdutoController.text = args.nomeproduto;
        _volumeController.text = args.volume;
        _precoVendaController.text = args.precoVenda.toStringAsFixed(2).replaceAll('.', ',');
        _quantidadeController.text = args.quantidade.toString();
      }
    }
    estadoCriado = true;
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'Cadastrar Produto' : 'Consultar Produto'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: const InputDecoration(label: Text('Nome do produto')),
                  controller: _nomeProdutoController,
                  validator: (value) {
                    if (value!.trim().length < 3) {
                      return 'Nome do produto muito curto';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  decoration: const InputDecoration(label: Text('Volume do Produto')),
                  controller: _volumeController,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextFormField(
                        decoration: const InputDecoration(label: Text('Preço Venda')),
                        controller: _precoVendaController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
                        validator: (value) {
                          double? val = double.tryParse(value!.replaceAll(',', '.'));
                          if (val == null || val <= 0) {
                            return 'Valor inválido';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: TextFormField(
                        decoration: const InputDecoration(label: Text('Quantidade')),
                        controller: _quantidadeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                        validator: (value) {
                          int? val = int.tryParse(value!);
                          if (val == null || val <= 0) {
                            return 'Quantidade inválida';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  String feed = isNew
                      ? await Produto(
                          nomeproduto: _nomeProdutoController.text,
                          volume: _volumeController.text,
                          precoVenda: double.tryParse(_precoVendaController.text.replaceAll(',', '.'))!,
                          quantidade: int.tryParse(_quantidadeController.text)!,
                        ).create()
                      : await Produto(
                          nomeproduto: _nomeProdutoController.text,
                          volume: _volumeController.text,
                          precoVenda: double.tryParse(_precoVendaController.text.replaceAll(',', '.'))!,
                          quantidade: int.tryParse(_quantidadeController.text)!,
                        ).update('prod_${args.nomeproduto}_${args.volume}');
                  if (!feed.startsWith('Erro') && isNew) {
                    _nomeProdutoController.text = '';
                    _volumeController.text = '';
                    _precoVendaController.text = '';
                    _quantidadeController.text = '';
                  }
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('EstoqueScreen');

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(feed),
                    ),
                  );
                },
                child: Text(isNew ? 'SALVAR NOVO PRODUTO' : 'ATUALIZAR PRODUTO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
