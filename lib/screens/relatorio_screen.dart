// ignore_for_file: use_build_context_synchronously

import 'package:controle_clube/models/relatorio.dart';
import 'package:flutter/material.dart';

class RelatorioScreen extends StatelessWidget {
  const RelatorioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              String response = await Relatorio(tipoRelatorio: TipoRelatorio.todosDevedores).gerarRelatorioTodosDevedores();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(response.startsWith('Arquivo salvo em: ') ? 'Sucesso' : 'Erro'),
                  content: Text(response),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Voltar'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Saldo devedor de todos')),
      ),
    );
  }
}
