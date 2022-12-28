// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:controle_clube/controllers/auth_controller.dart';
import 'package:controle_clube/models/carrinho.dart';
import 'package:controle_clube/models/compra.dart';
import 'package:controle_clube/models/produto.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import '../models/militar.dart';

class FinalizarCompraScreen extends StatefulWidget {
  const FinalizarCompraScreen({super.key});

  @override
  State<FinalizarCompraScreen> createState() => _FinalizarCompraScreenState();
}

class _FinalizarCompraScreenState extends State<FinalizarCompraScreen> {
  FormaPgto formaPgto = FormaPgto.aPrazoFO;

  @override
  Widget build(BuildContext context) {
    Carrinho args = ModalRoute.of(context)!.settings.arguments as Carrinho;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Compra'),
      ),
      body: args.isEmpty
          ? const Center(
              child: Text('Não há itens no carrinho'),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Valor total da compra',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          RadioListTile(
                            title: const Text('A prazo (FO)'),
                            value: formaPgto,
                            groupValue: FormaPgto.aPrazoFO,
                            onChanged: (value) {
                              setState(() {
                                formaPgto = FormaPgto.aPrazoFO;
                              });
                            },
                          ),
                          RadioListTile(
                            title: const Text('A vista (Pix)'),
                            value: formaPgto,
                            groupValue: FormaPgto.aVistaPix,
                            onChanged: (value) {
                              setState(() {
                                formaPgto = FormaPgto.aVistaPix;
                              });
                            },
                          ),
                          RadioListTile(
                            title: const Text('A vista (Dinheiro)'),
                            value: formaPgto,
                            groupValue: FormaPgto.aVistaDinheiro,
                            onChanged: (value) {
                              setState(() {
                                formaPgto = FormaPgto.aVistaDinheiro;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    leading:
                        CircleAvatar(radius: 45, child: Text(args.calcularValorTotal.toStringAsFixed(2).replaceAll('.', ','))),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            setState(() {
                              args.esvaziarCarrinho();
                            });
                          },
                          tooltip: 'Esvaziar carrinho',
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        List<Compra> comprasCarrinho = [];
                                        for (Produto produto in args.produtos) {
                                          comprasCarrinho.add(
                                            Compra(
                                              assinadoEletronico: false,
                                              atendenteVendeu: authdata!.militar.dbKey,
                                              foiPago: formaPgto == FormaPgto.aPrazoFO,
                                              formaPgto: formaPgto,
                                              valorVenda: produto.precoVenda,
                                              prodKey: produto.dbKey,
                                              quantidade: produto.quantidade,
                                              userComprou: args.militar,
                                            ),
                                          );
                                        }
                                        String notificacao = (await args.finalizarCompra(comprasCarrinho, false));
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(notificacao)));
                                      },
                                      child: const Text('Sim')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Não')),
                                ],
                                title: const Text('Importante!'),
                                content: const Text(
                                    'Fazendo isso você registrará uma compra do militar. Mas não é possível ter certeza que o usuario realmente comprou. Deseja realmente registrar a compra?'),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.brown,
                          ),
                          tooltip: 'Finalizar compra (não recomendado)',
                        ),
                        IconButton(
                          onPressed: () {
                            final TextEditingController senhaController = TextEditingController();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        // checar se a senha de quem comprou está correta antes
                                        Militar cliente = await Militar(
                                                postoGrad: args.militar.split('_')[1], nomeGuerra: args.militar.split('_')[2])
                                            .read();
                                        if (cliente.senha != 'p@s5_${md5.convert(utf8.encode(senhaController.text))}') {
                                          Navigator.of(context).pop();
                                          showDialog(
                                              context: context,
                                              builder: (context) => const AlertDialog(
                                                    title: Text('Senha incorreta!'),
                                                    content: Text('Tente novamente, caso o problema persista resete sua senha.'),
                                                  ));
                                        }
                                        List<Compra> comprasCarrinho = [];
                                        for (Produto produto in args.produtos) {
                                          comprasCarrinho.add(
                                            Compra(
                                              assinadoEletronico: true,
                                              atendenteVendeu: authdata!.militar.dbKey,
                                              foiPago: formaPgto == FormaPgto.aPrazoFO,
                                              formaPgto: formaPgto,
                                              valorVenda: produto.precoVenda,
                                              prodKey: produto.dbKey,
                                              quantidade: produto.quantidade,
                                              userComprou: args.militar,
                                            ),
                                          );
                                        }
                                        String notificacao = (await args.finalizarCompra(comprasCarrinho, true));
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(notificacao)));
                                      },
                                      child: const Text('Comprovar compra')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancelar')),
                                ],
                                title: const Text('Comprove que é você quem está comprando!'),
                                content: TextField(
                                  decoration: const InputDecoration(label: Text('Senha')),
                                  controller: senhaController,
                                  obscureText: true,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.done_all,
                            color: Colors.green,
                          ),
                          tooltip: 'Finalizar compra com assinatura',
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: args.produtos.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text('${args.produtos[index].nomeproduto} ${args.produtos[index].volume}'),
                      subtitle: Text(
                          'Quantidade: ${args.produtos[index].quantidade},\nPreço unitário: ${args.produtos[index].precoVenda.toStringAsFixed(2).replaceAll('.', ',')}'),
                      leading: CircleAvatar(
                          radius: 45,
                          child: Text((args.produtos[index].quantidade * args.produtos[index].precoVenda)
                              .toStringAsFixed(2)
                              .replaceAll('.', ','))),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            args.produtos.removeAt(index);
                          });
                        },
                        tooltip: 'Remover item',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
