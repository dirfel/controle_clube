import 'dart:convert';

import 'package:controle_clube/models/militar.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthData {
  Militar militar;

  AuthData({
    required this.militar,
  });

  bool get checarSeLogado {
    return militar != Militar();
  }

  Future<bool> checarLogin(String identidade, String senhaDigitada) async {
    String senhaTratada = 'p@s5_${md5.convert(utf8.encode(senhaDigitada))}';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chaves = prefs.getKeys().toList();
    for (String chave in chaves) {
      if (!chave.startsWith('mil_')) {
        continue;
      }
      Militar militar = await Militar(postoGrad: chave.split('_')[1], nomeGuerra: chave.split('_')[2]).read();

      if (militar.identidade == '' || militar.senha == '') {
        continue;
      } else if (identidade == militar.identidade && militar.isFuncionario && militar.senha == senhaTratada) {
        return true;
      }
    }
    return false;
  }
}
