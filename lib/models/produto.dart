import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Produto {
  //essa classe define funções para tratamento de militares no sistema

  //parâmetros da classe
  String nomeproduto;
  String volume;
  double precoVenda;
  int quantidade;

  //método construtor
  Produto({
    this.nomeproduto = '',
    this.volume = '',
    this.precoVenda = 0,
    this.quantidade = 0,
  });

  // Métodos JSON

  Produto.fromJson(Map<String, dynamic> json)
      : nomeproduto = json['nomeproduto'],
        volume = json['volume'],
        precoVenda = json['precoVenda'],
        quantidade = json['quantidade'];

  String toJson() => jsonEncode({
        'nomeproduto': nomeproduto,
        'volume': volume,
        'precoVenda': precoVenda,
        'quantidade': quantidade,
      });

  String get dbKey {
    return 'prod_${nomeproduto}_$volume';
  }

  //metodos de CRUD

  //CREATE
  Future<String> create() async {
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave do produto
    final String key = dbKey;
    // antes de criar o produto preciso checar se não existe um produto cadastrado com esses dados e retornar erro caso exista
    if (prefs.containsKey(key)) {
      // retorno erro
      return 'Erro! Produto já cadastrado no sistema.';
    } else {
      //prossigo
      // converto os dados da classe em texto
      final String value = toJson();
      prefs.setString(key, utf8.fuse(base64).encode(value));
      return 'Produto cadastrado com sucesso!';
    }
  }

  //READ
  Future<Produto> read() async {
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave do produto
    final String key = dbKey;
    // antes de ler o produto preciso checar se existe um produto cadastrado com esses dados e retornar erro caso não exista
    if (!prefs.containsKey(key)) {
      // retorno erro
      return Produto();
    } else {
      Produto produto = Produto.fromJson(jsonDecode(utf8.fuse(base64).decode(prefs.getString(key)!)));
      return produto;
    }
  }

  //UPDATE
  Future<String> update(String oldKey) async {
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave do produto
    final String newKey = dbKey;
    final String value = toJson();
    if (newKey == oldKey) {
      //se a nova chave for igual a velha chave:
      prefs.setString(newKey, utf8.fuse(base64).encode(value));
    } else if (!prefs.containsKey(newKey)) {
      //se a nova chave não estiver sendo usada:
      prefs.setString(newKey, utf8.fuse(base64).encode(value));
      prefs.remove(oldKey);
    } else {
      //se a nova chave estiver sendo usada retorna um erro:
      return 'Erro! Produto já existe no banco de dados';
    }
    return 'Produto atualizado com sucesso!';
  }

  //DELETE
  Future<String> delete() async {
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave do produto
    final String key = dbKey;
    if (!prefs.containsKey(key)) {
      // retorno erro
      return 'Erro! Produto não cadastrado no sistema.';
    } else {
      //prossigo deletando a chave
      prefs.remove(key);
      return 'Produto removido do banco de dados!';
    }
  }

  //derivativos do update:
  Future<String> adicionarQuantidade(Produto produto, int acrescimo) async {
    int quantAtual = (await read()).quantidade;

    quantidade = quantAtual + acrescimo;
    return update(produto.dbKey);
  }

  Future<String> reduzirQuantidade(int decrescimo) async {
    int quantAtual = (await read()).quantidade;
    if (quantAtual - decrescimo < 0) {
      return 'Quantidade não pode ser inferior a zero!';
    }
    quantidade = quantAtual - decrescimo;
    return update(dbKey);
  }
}
