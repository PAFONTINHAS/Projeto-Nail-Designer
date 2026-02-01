class AgendamentoEntity {

  AgendamentoEntity({
    required this.id,
    required this.data,
    required this.servicos,
    required this.valorTotal,
    required this.finalizado,
    required this.nomeCliente,
    required this.duracaoTotal,
    required this.contatoCliente,
  });

  final String id;
  final DateTime data;
  final bool finalizado;
  final int duracaoTotal;
  final double valorTotal;
  final String nomeCliente;
  final String contatoCliente;
  final List<String> servicos;

  Map<String, dynamic> toMap(){

    return {

      "id": id,
      "data": data,
      "finalizado": finalizado,
      "duracaoTotal": duracaoTotal,
      "valorTotal": valorTotal,
      "nomeCliente": nomeCliente,
      "contatoCliente": contatoCliente,
      "servicos": servicos,
    };

  }
}