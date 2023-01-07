// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:controle_clube/controllers/auth_controller.dart';
import 'package:controle_clube/models/militar.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../models/compra.dart';

class NovoMilitarScreen extends StatefulWidget {
  const NovoMilitarScreen({super.key});

  @override
  State<NovoMilitarScreen> createState() => _NovoMilitarScreenState();
}

class _NovoMilitarScreenState extends State<NovoMilitarScreen> {
  bool estadoCriado = false;
  String? ddm;
  final TextEditingController _nomeGuerraController = TextEditingController();
  final TextEditingController _idtController = TextEditingController();
  bool _isSocio = false;
  bool _isfuncionario = false;
  bool _resetSenha = false;
  late Militar args;
  late bool isNew;
  final _formKey = GlobalKey<FormState>();
  bool filtrarPagos = true;

  @override
  Widget build(BuildContext context) {
    if (!estadoCriado) {
      args = ModalRoute.of(context)!.settings.arguments as Militar? ?? Militar();
      isNew = args.toJson() == Militar().toJson();

      if (!isNew) {
        ddm = args.postoGrad;
        _nomeGuerraController.text = args.nomeGuerra;
        _idtController.text = args.identidade;
        _isSocio = args.isSocio;
        _isfuncionario = args.isFuncionario;
      }
    }
    estadoCriado = true;
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'Cadastrar Militar' : 'Consultar Militar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Obrigatório';
                              }
                              return null;
                            },
                            alignment: AlignmentDirectional.center,
                            hint: const Text('P/Grad'),
                            value: ddm,
                            items: const [
                              DropdownMenuItem(value: 'Gen', child: Text('Gen')),
                              DropdownMenuItem(value: 'Cel', child: Text('Cel')),
                              DropdownMenuItem(value: 'TC', child: Text('TC')),
                              DropdownMenuItem(value: 'Maj', child: Text('Maj')),
                              DropdownMenuItem(value: 'Cap', child: Text('Cap')),
                              DropdownMenuItem(value: '1º Ten', child: Text('1º Ten')),
                              DropdownMenuItem(value: '2º Ten', child: Text('2º Ten')),
                              DropdownMenuItem(value: 'Asp', child: Text('Asp')),
                              DropdownMenuItem(value: 'ST', child: Text('ST')),
                              DropdownMenuItem(value: '1º Sgt', child: Text('1º Sgt')),
                              DropdownMenuItem(value: '2º Sgt', child: Text('2º Sgt')),
                              DropdownMenuItem(value: '3º Sgt', child: Text('3º Sgt')),
                              DropdownMenuItem(value: 'Cb', child: Text('Cb')),
                              DropdownMenuItem(value: 'Sd EP', child: Text('Sd EP')),
                              DropdownMenuItem(value: 'Sd EV', child: Text('Sd EV')),
                              DropdownMenuItem(value: 'Civil', child: Text('Civil')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                ddm = value;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 3,
                          child: TextFormField(
                            decoration: const InputDecoration(label: Text('Nome de guerra')),
                            controller: _nomeGuerraController,
                            validator: (value) {
                              if (value!.trim().length < 3) {
                                return 'Nome de guerra muito curto';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          flex: 2,
                          child: TextFormField(
                            maxLength: 10,
                            keyboardType: const TextInputType.numberWithOptions(),
                            decoration: const InputDecoration(label: Text('Identidade'), counterText: ''),
                            controller: _idtController,
                            validator: (value) {
                              if (int.tryParse(value!) == null) {
                                return 'Deve conter apenas números';
                              } else if (value.trim().length != 10) {
                                return 'Deve conter 10 dígitos';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  CheckboxListTile(
                    value: _isSocio,
                    title: const Text('É sócio do clube'),
                    onChanged: (val) {
                      setState(() {
                        _isSocio = val!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    value: _isfuncionario,
                    title: const Text('É funcionário do clube'),
                    onChanged: (val) {
                      setState(() {
                        _isfuncionario = val!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    value: _resetSenha,
                    title: const Text('Resetar senha para o número da identidade'),
                    onChanged: (val) {
                      setState(() {
                        _resetSenha = val!;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Militar mil = Militar(
                            postoGrad: ddm!,
                            nomeGuerra: _nomeGuerraController.text,
                            identidade: _idtController.text,
                            isFuncionario: _isfuncionario,
                            isSocio: _isSocio,
                          );
                          String feed = isNew ? await mil.create() : await mil.update('mil_${args.postoGrad}_${args.nomeGuerra}');
                          if (_resetSenha || isNew) {
                            mil.resetarSenha();
                          }
                          if (!feed.startsWith('Erro') && isNew) {
                            _nomeGuerraController.text = '';
                            _idtController.text = '';
                            setState(() {
                              ddm = null;
                            });
                            _isSocio = false;
                            _isfuncionario = false;
                          }

                          if (authdata != null) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed('MilitaresScreen');
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text('Agora você já pode acessar')));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text('A identidade será a senha inicial')));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text('Feche e abra o aplicativo para poder utilizar')));
                            Navigator.of(context).pop();
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(feed),
                            ),
                          );
                        },
                        child: Text(isNew ? 'SALVAR NOVO MILITAR' : 'ATUALIZAR MILITAR'),
                      ),
                      SizedBox(width: isNew ? 0 : 20),
                      isNew
                          ? const SizedBox()
                          : ElevatedButton(
                              onPressed: () {
                                final TextEditingController senhaAtualController = TextEditingController();
                                final TextEditingController senhaNova1Controller = TextEditingController();
                                final TextEditingController senhaNova2Controller = TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (BuildContext context, void Function(void Function()) setState) {
                                      return AlertDialog(
                                        title: const Text('Altere a senha'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              obscureText: true,
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              controller: senhaAtualController,
                                              decoration: const InputDecoration(label: Text('Digite a senha atual')),
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              obscureText: true,
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              controller: senhaNova1Controller,
                                              decoration: const InputDecoration(label: Text('Digite nova senha')),
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              obscureText: true,
                                              onChanged: (value) {
                                                setState(() {});
                                              },
                                              controller: senhaNova2Controller,
                                              decoration: const InputDecoration(label: Text('Repita a nova senha')),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(senhaNova1Controller.text != senhaNova2Controller.text
                                                ? 'A nova senha não confere com sua repetição'
                                                : senhaNova1Controller.text.length <= 3
                                                    ? 'Mínimo 4 caracteres'
                                                    : args.senha != 'p@s5_${md5.convert(utf8.encode(senhaAtualController.text))}'
                                                        ? 'A senha digitada é incorreta'
                                                        : ''),
                                            const SizedBox(height: 10),
                                            TextButton(
                                                onPressed: senhaNova1Controller.text != senhaNova2Controller.text ||
                                                        senhaNova1Controller.text.trim().length <= 3 ||
                                                        args.senha !=
                                                            'p@s5_${md5.convert(utf8.encode(senhaAtualController.text))}'
                                                    ? null
                                                    : () {
                                                        args.trocarSenha(senhaNova1Controller.text);
                                                        Navigator.of(context).pop();
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            const SnackBar(content: Text('Senha alterada com sucesso!')));
                                                      },
                                                child: const Text('Alterar senha'))
                                          ],
                                        ),
                                      );
                                    });
                                  },
                                );
                              },
                              child: const Text('ALTERAR SENHA'),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            AppBar(
              title: const Text('Histórico de compras'),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        filtrarPagos = !filtrarPagos;
                      });
                    },
                    icon: Icon(filtrarPagos ? Icons.hide_source : Icons.remove_red_eye))
              ],
              automaticallyImplyLeading: false,
            ),
            FutureBuilder<List<Compra>>(
                future: args.compras,
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Compra c = snapshot.data![index];
                            return (filtrarPagos && c.foiPago)
                                ? const SizedBox()
                                : ListTile(
                                    leading: CircleAvatar(
                                      child: Text(
                                        c.foiPago ? 'Pago' : 'Não\nPago',
                                        style: const TextStyle(fontSize: 10),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    title: Text(
                                        '${c.prodKey.replaceAll('prod_', '').replaceAll('_', ' ')} (${c.formaPgto.name}${c.formaPgto == FormaPgto.aPrazoFO ? ', assinado eletronicamente: ${c.assinadoEletronico}' : ''})'),
                                    subtitle: Text(
                                        '${c.quantidade} X R\$ ${c.valorVenda.toStringAsFixed(2).replaceAll('.', ',')} = R\$ ${(c.quantidade * c.valorVenda).toStringAsFixed(2).replaceAll('.', ',')} em  ${c.dataHora!.day}/${c.dataHora!.month}/${c.dataHora!.year} ${c.dataHora!.hour}:${c.dataHora!.minute} (atendido por ${c.atendenteVendeu.replaceAll("mil_", "").replaceAll("_", " ")})'),
                                  );
                          },
                        );
                }),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        // height: 200,
        // width: 200,
        child: FittedBox(
          child: isNew
              ? null
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      heroTag: 'btn1',
                      tooltip: args.divida == 0 ? 'Sem débito ao clube' : 'Pagar Conta',
                      onPressed: args.divida == 0
                          ? null
                          : () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                      'Dívida atual do ${args.postoGrad} ${args.nomeGuerra}: R\$ ${args.divida.toStringAsFixed(2).replaceAll('.', ',')}'),
                                  content: const Text('Registrar pagamento integral do saldo devedor?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        await args.amortizarDivida();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Dívida paga'),
                                          ),
                                        );
                                      },
                                      child: const Text('Sim'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Não'),
                                    ),
                                  ],
                                ),
                              );
                            },
                      child: FutureBuilder<double>(
                          future: args.calcDivida,
                          builder: (context, snapshot) {
                            return !snapshot.hasData || snapshot.hasError
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Deve\n${snapshot.data!.toStringAsFixed(2).replaceAll('.', ',')}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 10),
                                  );
                          }),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      heroTag: 'btn2',
                      onPressed: () {
                        Navigator.of(context).pushNamed('NovaVendaScreen', arguments: args);
                      },
                      tooltip: 'Vender produtos',
                      child: const Icon(Icons.sell),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
