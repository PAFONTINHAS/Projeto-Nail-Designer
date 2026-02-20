class Servico {

  final String id;
  final String nome;
  final double preco;
  final int duracao;
  final String categoria;
  final bool servicoAtivo;


  Servico({
    required this.id,
    required this.nome,
    required this.preco,
    required this.duracao,
    required this.categoria,
    required this.servicoAtivo
  });

  Map<String, dynamic> toMap(){
    return {
      'nome': nome,
      'preco': preco,
      'duracao': duracao,
      'categoria': categoria,
      'servicoAtivo': servicoAtivo
    };
  }

  Servico copyWith({
    String? id,
    String? nome,
    double? preco,
    int? duracao,
    String? categoria,
    bool? servicoAtivo,

  }){
    return Servico(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      preco: preco ?? this.preco,
      duracao: duracao ?? this.duracao,
      categoria: categoria ?? this.categoria,
      servicoAtivo: servicoAtivo ?? this.servicoAtivo,
    );
  }


}
