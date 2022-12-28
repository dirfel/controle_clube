import 'dart:convert';
import 'dart:io' as io;

import 'package:shared_preferences/shared_preferences.dart';

import 'militar.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

enum TipoRelatorio {
  todosDevedores,
  todosDevedoresDetalhado,
  estoqueDisponivel,
}

class Relatorio {
  final TipoRelatorio tipoRelatorio;

  Relatorio({
    required this.tipoRelatorio,
  });

  Future<Map<String, double>> listarDebitos(bool detalhar) async {
    // //aqui será armazenado o dado de retorno
    Map<String, double> debitos = {};

    // //crio instancia de preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // //obtenho todas as chaves de militares
    Set<String> chaves = prefs.getKeys().where((element) => element.startsWith('mil_')).toSet();
    // //converto todas as chaves em instancias de militar
    for (String chave in chaves) {
      Militar c = Militar.fromJson(jsonDecode(utf8.fuse(base64).decode(prefs.getString(chave)!)));
      double divida = await c.calcDivida;
      if (divida > 0) {
        debitos.addAll({'${c.postoGrad} ${c.nomeGuerra}': divida});
      }
    }
    return debitos;
  }

  Future<bool> criarPasta(String path) async {
    bool pastaCriada = await io.Directory(path).exists(); // Page
    if (!pastaCriada) {
      await io.Directory(path).create(recursive: true);
    }
    return true;
  }

  Future<String> gerarRelatorioTodosDevedores() async {
    try {
      Map<String, double> debitos = await Relatorio(tipoRelatorio: TipoRelatorio.todosDevedores).listarDebitos(true);
      final pdf = pw.Document();
      List<String> debitosKeys = debitos.keys.toList();
      int pagina = 0;
      for (int index = 0; index < debitosKeys.length; index += 45) {
        pagina++;

        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              List<pw.TableRow> linhas = [
                pw.TableRow(
                  children: [
                    pw.Text(
                      'Militar',
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      'Débito (R\$)',
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      'Pago',
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ];
              for (int i = 45 * pagina - 45; i < 45 * pagina && i < debitosKeys.length; i++) {
                linhas.add(
                  pw.TableRow(
                    children: [
                      pw.Text(
                        debitosKeys[i],
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        debitos[debitosKeys[i]]!.toStringAsFixed(2).replaceAll('.', ','),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(''),
                    ],
                  ),
                );
              }
              return pw.Column(
                children: [
                  pw.Text('Relação de quem deve o clube'),
                  pw.Text('Gerado em: ${DateTime.now().toUtc().toLocal()}'),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    border: pw.TableBorder.all(),
                    children: linhas,
                  )
                ],
              );
            }));
      }

      String folderPath = 'C:\\\\Relatórios Clube';
      String filename = 'Relação de devedores ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}.pdf';
      await Relatorio(tipoRelatorio: TipoRelatorio.todosDevedores).criarPasta(folderPath);
      final file = io.File("$folderPath\\$filename");
      await file.writeAsBytes(await pdf.save());
      return 'Arquivo salvo em: $folderPath\\$filename';
    } catch (erro) {
      return erro.toString();
    }
  }
}
