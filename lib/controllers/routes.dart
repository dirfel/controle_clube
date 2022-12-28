import 'package:flutter/material.dart';

import '../screens/mensalidades_screen.dart';
import '../screens/militares_screen.dart';
import '../screens/nova_venda_screen.dart';
import '../screens/novo_militar_screen.dart';
import '../screens/novo_produto_screen.dart';
import '../screens/relatorio_screen.dart';
import '../screens/estoque_screen.dart';
import '../screens/finalizar_compra_screen.dart';

import '../screens/home_screen.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  'HomeScreen': (context) => const HomeScreen(),
  'MilitaresScreen': (context) => const MilitaresScreen(),
  'NovoMilitarScreen': (context) => const NovoMilitarScreen(),
  'NovoProdutoScreen': (context) => const NovoProdutoScreen(),
  'EstoqueScreen': (context) => const EstoqueScreen(),
  'NovaVendaScreen': (context) => const NovaVendaScreen(),
  'FinalizarCompraScreen': (context) => const FinalizarCompraScreen(),
  'RelatorioScreen': (context) => const RelatorioScreen(),
  'MensalidadesScreen': (context) => const MensalidadesScreen(),
};
