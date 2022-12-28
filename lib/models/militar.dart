import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'compra.dart';

class Militar {
  //essa classe define funções para tratamento de militares no sistema

  //parâmetros da classe
  String postoGrad;
  String nomeGuerra;
  bool isSocio;
  bool isFuncionario;
  String identidade;
  String senha;
  double divida;

  //método construtor
  Militar({
    this.postoGrad = '',
    this.nomeGuerra = '',
    this.isSocio = false,
    this.isFuncionario = false,
    this.identidade = '',
    this.senha = '',
    this.divida = 0,
  });

  // Métodos JSON

  Militar.fromJson(Map<String, dynamic> json)
      : postoGrad = json['postoGrad'],
        nomeGuerra = json['nomeGuerra'],
        isSocio = json['isSocio'],
        isFuncionario = json['isFuncionario'],
        identidade = json['identidade'] ?? '',
        senha = json['senha'] ?? '',
        divida = json['divida'] ?? 0;

  String toJson() => jsonEncode({
        'postoGrad': postoGrad,
        'nomeGuerra': nomeGuerra,
        'isSocio': isSocio,
        'isFuncionario': isFuncionario,
        'identidade': identidade,
        'senha': (senha.startsWith('p@s5_')) ? senha : 'p@s5_${md5.convert(utf8.encode(senha))}',
        'divida': divida,
      });

  String get dbKey {
    return 'mil_${postoGrad}_$nomeGuerra';
  }

  //metodos de CRUD

  //CREATE
  Future<String> create() async {
    senha = 'p@s5_${md5.convert(utf8.encode(identidade))}';
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave do usuário
    final String key = dbKey;
    // antes de criar o militar preciso checar se não existe um usuário cadastrado com esses dados e retornar erro caso exista
    if (prefs.containsKey(key)) {
      // retorno erro
      return 'Erro! Usuário já cadastrado no sistema.';
    } else {
      //prossigo
      // converto os dados da classe em texto
      final String value = toJson();
      prefs.setString(key, utf8.fuse(base64).encode(value));
      return 'Usuário cadastrado com sucesso!';
    }
  }

  //READ
  Future<Militar> read() async {
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave do usuário
    final String key = dbKey;
    // antes de ler o militar preciso checar se existe um usuário cadastrado com esses dados e retornar erro caso não exista
    if (!prefs.containsKey(key)) {
      // retorno erro
      return Militar();
    } else {
      Militar militar = Militar.fromJson(jsonDecode(utf8.fuse(base64).decode(prefs.getString(key)!)));
      militar.divida = await militar.calcDivida;
      return militar;
    }
  }

  //UPDATE
  Future<String> update(String oldKey) async {
    if (senha == '') {
      senha = await _senhaHash;
    }
    //crio uma instancia de conexão com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave do usuário
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
      return 'Erro! Usuário já existe no banco de dados';
    }
    return 'Usuário atualizado com sucesso!';
  }

  //DELETE
  Future<String> delete() async {
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //defino a chave do usuário
    final String key = dbKey;
    if (!prefs.containsKey(key)) {
      // retorno erro
      return 'Erro! Usuário não cadastrado no sistema.';
    } else {
      //prossigo deletando a chave
      prefs.remove(key);
      return 'Usuário removido do banco de dados!';
    }
  }

  //Checar senha para comprar produtos:
  checarSenha(String senhaDigitada) {
    //preparo a senha para comparação:
    String hash = 'p@s5_${md5.convert(utf8.encode(senhaDigitada))}';
    return senha == hash;
  }

  resetarSenha() {
    senha = 'p@s5_${md5.convert(utf8.encode(senha))}';
  }

  Future<String> get _senhaHash async {
    String senhaHash = (await read()).senha;
    return senhaHash;
  }

  trocarSenha(String novaSenha) {
    senha = 'p@s5_${md5.convert(utf8.encode(novaSenha))}';
    update(dbKey);
  }

  amortizarDivida() async {
    List<Compra> comprasList = await compras;
    for (Compra compra in comprasList) {
      if (!compra.foiPago) {
        compra.registrarPgto('compra_${compra.dataHora!.millisecondsSinceEpoch}');
      }
    }
    divida = 0;
  }

  Future<List<Compra>> get compras async {
    //defino a variavel que será retornada
    List<Compra> compras = [];
    //crio uma instancia de conecção com o banco de dados
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> chavesDB = prefs.getKeys();
    for (String chaveDB in chavesDB) {
      if (chaveDB.startsWith('compra_')) {
        String conteudo = utf8.fuse(base64).decode(prefs.getString(chaveDB)!);
        Compra c = Compra.fromJson(jsonDecode(conteudo));
        if (c.userComprou == dbKey) {
          c.dataHora = DateTime.fromMillisecondsSinceEpoch(int.tryParse(chaveDB.replaceAll('compra_', '')) ?? 0);
          compras.add(c);
        }
      }
    }
    return compras;
  }

  Future<double> get calcDivida async {
    double div = 0;
    List<Compra> comprasList = await compras;
    for (Compra compra in comprasList) {
      if (!compra.foiPago) {
        div += compra.quantidade * compra.valorVenda;
      }
    }
    return div;
  }

  Future<Militar> get readFromIdt async {
    if (identidade == '') {
      return Militar();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> chaves = prefs.getKeys();
    for (String chave in chaves) {
      if (!chave.contains('mil_')) {
        continue;
      }
      Militar idtch = await Militar(nomeGuerra: chave.split('_')[2], postoGrad: chave.split('_')[1]).read();

      if (idtch.identidade == identidade) {
        return idtch;
      }
    }

    return Militar();
  }
}
