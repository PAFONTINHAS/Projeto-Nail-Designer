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
  });

  factory RelatorioMensalModel.fromSnapshot(DocumentSnapshot doc){
    final data = doc.data() as Map<String,dynamic>;

    final faturamentoPorCategoriaRaw = data['faturamentoPorCategoria'] as Map<String, dynamic>? ?? {};

    final Map<String, double> fatuamentoPorCategoria = faturamentoPorCategoriaRaw.map((key, value)=> MapEntry(
      key,
      (value is int) ? value.toDouble() : (value as double) 
    ));

    final faturamentoRealizado = isInt(data['faturamentoRealizado'])
        ? (data['faturamentoRealizado'] as int).toDouble()
        : data['faturamentoRealizado'];

    final ticketMedio = isInt(data['ticketMedio'])
        ? (data['ticketMedio'] as int).toDouble()
        : data['ticketMedio'];

    logger.i("Relatorio encontrado: $data");

    return RelatorioMensalModel(
      id: doc.id,
      ticketMedio: ticketMedio,
      faturamentoRealizado: faturamentoRealizado,
      clientesAtendidos: data['clientesAtendidos'],
      totalAtendimentos: data['totalAtendimentos'],
      faturamentoPorCategoria: fatuamentoPorCategoria
    );
  }


}