// ignore_for_file: use_build_context_synchronously

import 'package:controle_clube/models/carrinho.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/auth_controller.dart';
import '../models/compra.dart';
import '../models/militar.dart';
import '../models/produto.dart';

class MensalidadesScreen extends StatefulWidget {
  const MensalidadesScreen({super.key});

  @override
  State<MensalidadesScreen> createState() => _MensalidadesScreenState();
}

class _MensalidadesScreenState extends State<MensalidadesScreen> {
  final TextEditingController _genController = TextEditingController();
  final TextEditingController _celController = TextEditingController();
  final TextEditingController _tcController = TextEditingController();
  final TextEditingController _majController = TextEditingController();
  final TextEditingController _capController = TextEditingController();
  final TextEditingController _ten1Controller = TextEditingController();
  final TextEditingController _ten2Controller = TextEditingController();
  final TextEditingController _aspController = TextEditingController();
  final TextEditingController _stController = TextEditingController();
  final TextEditingController _sgt1Controller = TextEditingController();
  final TextEditingController _sgt2Controller = TextEditingController();
  final TextEditingController _sgt3Controller = TextEditingController();
  final TextEditingController _cbController = TextEditingController();
  final TextEditingController _sdepController = TextEditingController();
  final TextEditingController _sdevController = TextEditingController();
  final TextEditingController _civilController = TextEditingController();

  Future<bool> future() async {
    List<String> list = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    list =
        prefs.getStringList('mensalidades') ?? ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'];

    _genController.text = list[0];
    _celController.text = list[1];
    _tcController.text = list[2];
    _majController.text = list[3];
    _capController.text = list[4];
    _ten1Controller.text = list[5];
    _ten2Controller.text = list[6];
    _aspController.text = list[7];
    _stController.text = list[8];
    _sgt1Controller.text = list[9];
    _sgt2Controller.text = list[10];
    _sgt3Controller.text = list[11];
    _cbController.text = list[12];
    _sdepController.text = list[13];
    _sdevController.text = list[14];
    _civilController.text = list[15];
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mensalidades')),
      body: FutureBuilder<bool>(
          future: future(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Registre o valor da mensalidade para cada posto/graduação'),
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, childAspectRatio: 1.8),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('Gen')),
                                  controller: _genController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('Cel')),
                                  controller: _celController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('TC')),
                                  controller: _tcController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('Maj')),
                                  controller: _majController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('Cap')),
                                  controller: _capController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('1º Ten')),
                                  controller: _ten1Controller,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('2º Ten')),
                                  controller: _ten2Controller,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('Asp')),
                                  controller: _aspController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('ST')),
                                  controller: _stController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('1º Sgt')),
                                  controller: _sgt1Controller,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('2º Sgt')),
                                  controller: _sgt2Controller,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('3º Sgt')),
                                  controller: _sgt3Controller,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('Cb')),
                                  controller: _cbController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('Sd EP')),
                                  controller: _sdepController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('Sd EV')),
                                  controller: _sdevController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  maxLength: 6,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  decoration: const InputDecoration(counter: Text(''), label: Text('Civil')),
                                  controller: _civilController,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                //chamo a instancha de shared prefs
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                List<String> valores = [
                                  (double.tryParse(_genController.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_celController.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_tcController.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_majController.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_capController.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_ten1Controller.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_ten2Controller.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_aspController.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_stController.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_sgt1Controller.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_sgt2Controller.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_sgt3Controller.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_cbController.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_sdepController.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_sdevController.text.replaceAll(',', '.')) ?? 0).toString(),
                                  (double.tryParse(_civilController.text.replaceAll(',', '.')) ?? 0).toString(),
                                ];
                                await prefs.setStringList('mensalidades', valores);
                                Navigator.of(context).popAndPushNamed('MensalidadesScreen');
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Valores atualizados')));
                              },
                              child: const Text('Atualizar valores')),
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Confirmação'),
                                    content: const Text(
                                        'Fazendo isso, todos os militares mercados como sócios terão o valor da mensalidade acrecido dos seus débitos.'),
                                    actions: [
                                      ElevatedButton(
                                          onPressed: () async {
                                            /*sequencia:
                                              1. Obter a lista de militares
                                              */
                                            SharedPreferences prefs = await SharedPreferences.getInstance();

                                            List<String> chaves =
                                                prefs.getKeys().where((element) => element.startsWith('mil_')).toList();

                                            // 2. Para cada militar:
                                            for (String chave in chaves) {
                                              Militar mil =
                                                  await Militar(postoGrad: chave.split('_')[1], nomeGuerra: chave.split('_')[2])
                                                      .read();
                                              // 2.a. Ver se é sócio
                                              if (mil.isSocio) {
                                                String valMens = '';
                                                switch (mil.postoGrad) {
                                                  case 'Gen':
                                                    valMens = _genController.text;
                                                    break;
                                                  case 'Cel':
                                                    valMens = _celController.text;
                                                    break;
                                                  case 'TC':
                                                    valMens = _tcController.text;
                                                    break;
                                                  case 'Maj':
                                                    valMens = _majController.text;
                                                    break;
                                                  case 'Cap':
                                                    valMens = _capController.text;
                                                    break;
                                                  case '1º Ten':
                                                    valMens = _ten1Controller.text;
                                                    break;
                                                  case '2º Ten':
                                                    valMens = _ten2Controller.text;
                                                    break;
                                                  case 'Asp':
                                                    valMens = _aspController.text;
                                                    break;
                                                  case 'ST':
                                                    valMens = _stController.text;
                                                    break;
                                                  case '1º Sgt':
                                                    valMens = _sgt1Controller.text;
                                                    break;
                                                  case '2º Sgt':
                                                    valMens = _sgt2Controller.text;
                                                    break;
                                                  case '3º Sgt':
                                                    valMens = _sgt3Controller.text;
                                                    break;
                                                  case 'Cb':
                                                    valMens = _cbController.text;
                                                    break;
                                                  case 'Sd EP':
                                                    valMens = _sdepController.text;
                                                    break;
                                                  case 'Sd EV':
                                                    valMens = _sdevController.text;
                                                    break;
                                                  case 'Civil':
                                                    valMens = _civilController.text;
                                                    break;
                                                  default:
                                                    break;
                                                }

                                                Produto prod = Produto(
                                                    nomeproduto: 'Mensalidade',
                                                    precoVenda: double.tryParse(valMens) ?? 0,
                                                    quantidade: 0,
                                                    volume: 'Mês');
                                                List<Compra> comprasCarrinho = [
                                                  Compra(
                                                    assinadoEletronico: false,
                                                    atendenteVendeu: authdata!.militar.dbKey,
                                                    foiPago: false,
                                                    formaPgto: FormaPgto.aPrazoFO,
                                                    valorVenda: double.tryParse(valMens) ?? 0,
                                                    prodKey: prod.dbKey,
                                                    quantidade: 1,
                                                    userComprou: mil.dbKey,
                                                  ),
                                                ];
                                                Carrinho carrinho = Carrinho(produtos: [prod], militar: chave);
                                                await carrinho.finalizarCompra(comprasCarrinho, false);
                                              }
                                            }
                                          },
                                          child: const Text('Confirmar')),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar')),
                                    ],
                                  ),
                                );
                              },
                              child: const Text('Cobrar mensalidade')),
                        ],
                      ),
                    ],
                  ));
          }),
    );
  }
}
