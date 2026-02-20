import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/core/utils/helpers.dart';
import 'package:mobile/features/agenda/domain/entities/agenda.dart';

class AgendaModel extends Agenda{

  AgendaModel({
    required super.diasTrabalho,
    required super.horarioFim,
    required super.horarioInicio,
    required super.datasBloqueadas,
    super.agendaAtiva
  });

  factory AgendaModel.fromSnapshot(DocumentSnapshot doc){

    final data = doc.data() as Map<String, dynamic>;

    return AgendaModel(
      diasTrabalho: List<int>.from(data['diasTrabalho']),
      horarioFim: data['horarioFim'],
      horarioInicio: data['horarioInicio'],
      datasBloqueadas: List<String>.from(data['datasBloqueadas'] ?? []),
      agendaAtiva: data['agendaAtiva']
    );
  }

}

extension ListDateExtension on List<Timestamp>{
  
  List<DateTime> converterDatas(){

    if(isEmpty) return [];

    final List<DateTime> datas = [];

    for(final timestamp in this){

      final dataConvertida = toDate(timestamp);

      if(dataConvertida == null) continue;

      datas.add(dataConvertida);
    }

    return datas;

  }

}