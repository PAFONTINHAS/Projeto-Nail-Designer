class RelatorioMensal {

  final String id;

  final double ticketMedio;
  final double valorPerdidoFaltas;
  final double faturamentoRealizado;

  final int totalFaltas;
  final int totalCancelamentos;
  final int clientesAtendidos;
  final int totalAtendimentos;
  
  final Map<String, double> faturamentoPorCategoria;
  
  RelatorioMensal({
    required this.id,
    required this.ticketMedio,
    required this.clientesAtendidos,
    required this.totalAtendimentos,
    required this.faturamentoRealizado,
    required this.faturamentoPorCategoria,
    required this.totalCancelamentos,
    required this.totalFaltas,
    required this.valorPerdidoFaltas
  });

  factory RelatorioMensal.fromMap(Map<String, dynamic> map){
    return RelatorioMensal(
      id: map['id'],
      ticketMedio: map['ticketMedio'],
      totalFaltas: map['totalFaltas'],
      totalCancelamentos: map['totalCancelamentos'],
      totalAtendimentos: map['totalAtendimentos'],
      clientesAtendidos: map['clientesAtendidos'],
      valorPerdidoFaltas: map['valorPerdidoFaltas'],
      faturamentoRealizado: map['faturamentoRealizado'],
      faturamentoPorCategoria: map['faturamentoPorCategoria'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalFaltas': totalFaltas,
      'ticketMedio': ticketMedio,
      'totalCancelamentos': totalCancelamentos,
      'totalAtendimentos': totalAtendimentos,
      'clientesAtendidos': clientesAtendidos,
      'valorPerdidoFaltas': valorPerdidoFaltas,
      'faturamentoRealizado': faturamentoRealizado,
      'faturamentoPorCategoria': faturamentoPorCategoria,
    };
  }
  
}