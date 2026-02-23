import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/core/utils/helpers.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';
import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';

class RelatorioMensalModel extends RelatorioMensal {
  RelatorioMensalModel({
    required super.id,
    required super.ticketMedio,
    required super.clientesAtendidos,
    required super.totalAtendimentos,
    required super.faturamentoRealizado,
    required super.faturamentoPorCategoria,
    required super.totalCancelamentos,
    required super.totalFaltas,
    required super.valorPerdidoFaltas
  });

  factory RelatorioMensalModel.fromSnapshot(DocumentSnapshot doc){
    final data = doc.data() as Map<String,dynamic>;

    final faturamentoPorCategoriaRaw = data['faturamentoPorCategoria'] as Map<String, dynamic>? ?? {};

    final Map<String, double> fatuamentoPorCategoria = faturamentoPorCategoriaRaw.map((key, value)=> MapEntry(
      key,
      (value is int) ? tranformIntoOneDecimal(value.toDouble()) : (value as double) 
    ));

    final faturamentoRealizado = isInt(data['faturamentoRealizado'])
        ? tranformIntoOneDecimal((data['faturamentoRealizado'] as int).toDouble()) 
        : data['faturamentoRealizado'];

    final ticketMedio = isInt(data['ticketMedio'])
        ? tranformIntoOneDecimal((data['ticketMedio'] as int).toDouble())
        : data['ticketMedio'];

    final valorPerdidoFaltas = isInt(data['valorPerdidoFaltas'])  
      ? tranformIntoOneDecimal((data['valorPerdidoFaltas'] as int).toDouble())
      : data['valorPerdidoFaltas'];

    logger.i("Relatorio encontrado: $data");

    return RelatorioMensalModel(
      id: doc.id,
      ticketMedio: ticketMedio,
      faturamentoRealizado: faturamentoRealizado,
      clientesAtendidos: data['clientesAtendidos'],
      totalAtendimentos: data['totalAtendimentos'],
      faturamentoPorCategoria: fatuamentoPorCategoria,
      totalFaltas: data['totalFaltas'],
      totalCancelamentos: data['totalCancelamentos'],
      valorPerdidoFaltas: valorPerdidoFaltas
    );
  }

  factory RelatorioMensalModel.fromRelatorioMensal(RelatorioMensal relatorio){
    return RelatorioMensalModel(
      id: relatorio.id,
      ticketMedio: relatorio.ticketMedio,
      clientesAtendidos: relatorio.clientesAtendidos,
      totalAtendimentos: relatorio.totalAtendimentos,
      faturamentoRealizado: relatorio.faturamentoRealizado,
      faturamentoPorCategoria: relatorio.faturamentoPorCategoria,
      valorPerdidoFaltas: relatorio.valorPerdidoFaltas,
      totalCancelamentos: relatorio.totalCancelamentos,
      totalFaltas: relatorio.totalFaltas
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'totalFaltas': totalFaltas,
      'ticketMedio': ticketMedio,
      'totalAtendimentos': totalAtendimentos,
      'clientesAtendidos': clientesAtendidos,
      'valorPerdidoFaltas': valorPerdidoFaltas,
      'totalCancelamentos': totalCancelamentos,
      'faturamentoRealizado': faturamentoRealizado,
      'faturamentoPorCategoria': faturamentoPorCategoria,
      
    };
  }
  


}