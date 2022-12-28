import 'package:controle_clube/models/compra.dart';
import 'package:controle_clube/models/produto.dart';

class Carrinho {
  final String militar;
  final List<Produto> produtos;

  Carrinho({
    required this.militar,
    required this.produtos,
  });

  //checar se o carrinho está vazio:
  bool get isEmpty {
    return produtos.isEmpty;
  }

  double get calcularValorTotal {
    double total = 0;
    for (var element in produtos) {
      total += (element.precoVenda * element.quantidade);
    }
    return total;
  }

  // adicionar item ao carrinho
  adicionarProdutoCarrinho(Produto produto) {
    produtos.add(produto);
  }

  // ler item do carrinho
  Produto verProdutoCarrinho(Produto produto) {
    List<Produto> pList =
        produtos.where((element) => produto.nomeproduto == element.nomeproduto && produto.volume == element.volume).toList();
    if (pList.isEmpty) {
      return produto;
    } else {
      return pList[0];
    }
  }

  // atualizar item do carrinho
  atualizarProdutoCarrinho(Produto produto, double novoPreco, int novaQuant) {
    int indexProd =
        produtos.indexWhere((element) => element.nomeproduto == produto.nomeproduto && element.volume == produto.volume);
    produtos[indexProd] = Produto(
      nomeproduto: produtos[indexProd].nomeproduto,
      volume: produtos[indexProd].volume,
      precoVenda: novoPreco,
      quantidade: novaQuant,
    );
  }

  // deletar item carrinho
  deletarProdutoCarrinho(Produto produto) {
    produtos.removeWhere((element) => element == verProdutoCarrinho(produto));
  }

  esvaziarCarrinho() {
    while (produtos.isNotEmpty) {
      produtos.removeAt(0);
    }
  }

  Future<String> finalizarCompra(List<Compra> compras, bool assinado) async {
    // cria a compra
    for (var compra in compras) {
      compra.create(assinado);
      (await compra.prodFromKey).reduzirQuantidade(compra.quantidade);
    }
    return 'Compra cadastrada com sucesso';
  }
}
