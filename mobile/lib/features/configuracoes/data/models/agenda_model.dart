import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/features/configuracoes/domain/entities/agenda.dart';

class AgendaModel extends Agenda{

  AgendaModel({
    required super.diasTrabalho,
    required super.horarioFim,
    required super.horarioInicio
  });

  factory AgendaModel.fromSnapshot(DocumentSnapshot doc){

    final data = doc.data() as Map<String, dynamic>;

    return AgendaModel(
      diasTrabalho: List<int>.from(data['diasTrabalho']),
      horarioFim: data['horarioFim'],
      horarioInicio: data['horarioInicio'],
    );
  }
}