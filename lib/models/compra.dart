import 'dart:convert';

import 'package:controle_clube/models/produto.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FormaPgto {
  aVistaPix,
  aVistaDinheiro,
  aPrazoFO,
  naoInformado,
}

FormaPgto stringToFormaPgto(String string) {
  if (string == 'aPrazoFO') {
    return FormaPgto.aPrazoFO;
  } else if (string == 'aVistaDinheiro') {
    return FormaPgto.aVistaDinheiro;
  } else if (string == 'aVistaPix') {
    return FormaPgto.aVistaPix;
  } else {
    return FormaPgto.naoInformado;
  }
}

class Compra {
  String prodKey;
  int quantidade;
  double valorVenda;
  String userComprou;
  String atendenteVendeu;
  FormaPgto formaPgto;
  bool assinadoEletronico;
  bool foiPago;
  DateTime? dataHora;

  Compra({
    this.prodKey = '',
    this.quantidade = 0,
    this.valorVenda = 0,
    this.userComprou = '',
    this.atendenteVendeu = '',
    this.formaPgto = FormaPgto.naoInformado,
    this.assinadoEletronico = false,
    this.foiPago = false,
  });

// Métodos JSON

  Compra.fromJson(Map<String, dynamic> json)
      : prodKey = json['prodKey'],
        quantidade = json['quantidade'],
        valorVenda = json['valorVenda'],
        userComprou = json['userComprou'],
        atendenteVendeu = json['atendenteVendeu'],
        formaPgto = stringToFormaPgto(json['formaPgto']),
        assinadoEletronico = json['assinadoEletronico'],
        foiPago = json['foiPago'];

  String toJson() => jsonEncode({
        'prodKey': prodKey,
        'quantidade': quantidade,
        'valorVenda': valorVenda,
        'userComprou': userComprou,
        'atendenteVendeu': atendenteVendeu,
        'formaPgto': formaPgto.name,
        'assinadoEletronico': assinadoEletronico,
        'foiPago': foiPago,
      });

  // essa é a forma que gerará a chave para salvar no banco de dados
  String get dbKey {
    DateTime dataHora = DateTime.now();
    return 'compra_${dataHora.millisecondsSinceEpoch}';
  }

  Future<Produto> get prodFromKey async {
    if (prodKey == '') {
      return Produto();
    } else {
      List<String> list = prodKey.split('_');
      Produto produto = Produto(nomeproduto: list[1], volume: list[2]);

      Produto prodCerto = await produto.read();
      return prodCerto;
    }
  }

  //metodos de CRUD

  //CREATE
  Future<String> create(bool assinado) async {
    foiPago = formaPgto != FormaPgto.aPrazoFO;
    assinadoEletronico = assinado;
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave da compra
    final String key = dbKey;
    // antes de criar a compra preciso checar se não existe uma compra cadastrada com esses dados e retornar erro caso exista
    if (prefs.containsKey(key)) {
      // retorno erro
      return 'Erro! Compra já cadastrada no sistema.';
    } else {
      //prossigo
      // converto os dados da classe em texto
      final String value = toJson();
      prefs.setString(key, utf8.fuse(base64).encode(value));
      return 'Compra cadastrada com sucesso!';
    }
  }

  //READ
  Future<Compra> read() async {
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave da compra
    final String key = dbKey;
    // antes de ler a compra preciso checar se existe uma compra cadastrada com esses dados e retornar erro caso não exista
    if (!prefs.containsKey(key)) {
      // retorno erro
      return Compra();
    } else {
      Compra compra = Compra.fromJson(jsonDecode(utf8.fuse(base64).decode(prefs.getString(key)!)));
      compra.dataHora = DateTime.fromMillisecondsSinceEpoch(int.tryParse(dbKey.replaceAll('compra_', '')) ?? 0);
      return compra;
    }
  }

  //UPDATE
  Future<String> update(String oldKey) async {
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave do usuário
    final String value = toJson();
    prefs.setString(oldKey, utf8.fuse(base64).encode(value));
    return 'Compra atualizada com sucesso!';
  }

  //DELETE
  Future<String> delete() async {
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave do usuário
    final String key = dbKey;
    if (!prefs.containsKey(key)) {
      // retorno erro
      return 'Erro! Compra não cadastrada no sistema.';
    } else {
      //prossigo deletando a chave
      prefs.remove(key);
      return 'Compra removida do banco de dados!';
    }
  }

  registrarPgto(String key) async {
    foiPago = true;
    update(key);
  }
}
