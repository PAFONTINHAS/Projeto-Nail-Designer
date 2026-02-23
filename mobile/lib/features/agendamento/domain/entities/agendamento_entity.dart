class AgendamentoEntity {

  AgendamentoEntity({
    required this.id,
    required this.data,
    required this.status,
    required this.servicos,
    required this.valorTotal,
    // required this.finalizado,
    required this.nomeCliente,
    required this.duracaoTotal,
    required this.contatoCliente,
    required this.notificacaoEnviada,
  });

  final String id;
  final DateTime data;
  final String status;
  // final bool finalizado;
  final int duracaoTotal;
  final double valorTotal;
  final String nomeCliente;
  final String contatoCliente;
  final List<String> servicos;
  final bool notificacaoEnviada;

  Map<String, dynamic> toMap(){

    return {

      "id": id,
      "data": data,
      "status": status,
      "servicos": servicos,
      // "finalizado": finalizado,
      "valorTotal": valorTotal,
      "nomeCliente": nomeCliente,
      "duracaoTotal": duracaoTotal,
      "contatoCliente": contatoCliente,
      "notificacaoEnviada": notificacaoEnviada
    };

  }
}