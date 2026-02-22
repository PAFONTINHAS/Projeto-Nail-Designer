class RelatorioMensal {

  final String id;
  final double ticketMedio;
  final int clientesAtendidos;
  final int totalAtendimentos;
  final double faturamentoRealizado;
  final Map<String, double> faturamentoPorCategoria;
  
  RelatorioMensal({
    required this.id,
    required this.ticketMedio,
    required this.clientesAtendidos,
    required this.totalAtendimentos,
    required this.faturamentoRealizado,
    required this.faturamentoPorCategoria,
  });

  factory RelatorioMensal.fromMap(Map<String, dynamic> map){
    return RelatorioMensal(
      id: map['id'],
      ticketMedio: map['ticketMedio'],
      totalAtendimentos: map['totalAtendimentos'],
      clientesAtendidos: map['clientesAtendidos'],
      faturamentoRealizado: map['faturamentoRealizado'],
      faturamentoPorCategoria: map['faturamentoPorCategoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ticketMedio': ticketMedio,
      'totalAtendimentos': totalAtendimentos,
      'clientesAtendidos': clientesAtendidos,
      'faturamentoRealizado': faturamentoRealizado,
      'faturamentoPorCategoria': faturamentoPorCategoria,
    };
  }
  
}