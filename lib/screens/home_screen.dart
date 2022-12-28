// ignore_for_file: use_build_context_synchronously

import 'package:controle_clube/controllers/auth_controller.dart';
import 'package:controle_clube/models/auth_data.dart';
import 'package:controle_clube/models/militar.dart';
import 'package:controle_clube/widgets/home_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _idtController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _loading = false;
  submit() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> chaves = prefs.getKeys();
    if (chaves.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Não existem dados cadastrados ainda!'),
          content: const Text('Crie sua conta como funcionário para iniciar a usar o programa.'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popAndPushNamed('NovoMilitarScreen');
                },
                child: const Text('Começar')),
          ],
        ),
      );
    }
    Militar milDaIdt = await Militar(identidade: _idtController.text).readFromIdt;
    bool sucessoNoLogin = await AuthData(militar: milDaIdt).checarLogin(_idtController.text, _senhaController.text);
    _loading = false;
    if (!sucessoNoLogin) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Erro!'),
          content: Text('Usuário ou senha incorretos.'),
        ),
      );
    } else {
      authdata = AuthData(militar: milDaIdt);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle do clube'),
        actions: authdata == null
            ? null
            : [
                IconButton(
                  onPressed: () {
                    _idtController.text = '';
                    _senhaController.text = '';
                    setState(() {
                      authdata = null;
                    });
                  },
                  icon: const Icon(Icons.logout),
                  tooltip: 'Sair',
                )
              ],
      ),
      body: authdata == null
          ? _loading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width > 400 ? 400 : null,
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Para acessar o sistema, faça o login primeiro'),
                          const SizedBox(height: 10),
                          TextField(
                            keyboardType: const TextInputType.numberWithOptions(),
                            controller: _idtController,
                            decoration: const InputDecoration(
                              label: Text('Identidade (somente números)'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            onSubmitted: (value) => submit(),
                            obscureText: true,
                            controller: _senhaController,
                            decoration: const InputDecoration(
                              label: Text('Senha'),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () async {
                              await submit();
                            },
                            child: const Text('ACESSAR'),
                          ),
                        ],
                      ),
                    )),
                  ),
                )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250, mainAxisSpacing: 10, crossAxisSpacing: 10),
                  children: const [
                    HomeGridTile(
                      label: 'Militares',
                      icon: Icons.people,
                      route: 'MilitaresScreen',
                    ),
                    HomeGridTile(
                      label: 'Controle de Estoque',
                      icon: Icons.store,
                      route: 'EstoqueScreen',
                    ),
                    HomeGridTile(
                      label: 'Relatórios',
                      icon: Icons.receipt_long_sharp,
                      route: 'RelatorioScreen',
                    ),
                    HomeGridTile(
                      label: 'Controle de Mensalidades',
                      icon: Icons.monetization_on,
                      route: 'MensalidadesScreen',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
