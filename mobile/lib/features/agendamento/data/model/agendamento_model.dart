import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';


class AgendamentoModel extends AgendamentoEntity {
  AgendamentoModel({
    required super.id,
    required super.data,
    required super.status,
    required super.servicos,
    // required super.finalizado,
    required super.valorTotal,
    required super.nomeCliente,
    required super.duracaoTotal,
    required super.contatoCliente,
  });

  factory AgendamentoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AgendamentoModel(
      id: doc.id,
      nomeCliente: data['clienteNome'] ?? '',
      contatoCliente: data['contato'] ?? '',
      data: (data['data'] as Timestamp).toDate(),
      servicos: List<String>.from(data['servicos'] ?? []),
      valorTotal: (data['valorTotal'] as num).toDouble(),
      duracaoTotal: data['duracaoTotal'] ?? 0,
      // finalizado: data['finalizado'],
      status: data['status'] ?? ''
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'statis': status,
      'servicos': servicos,
      'valorTotal': valorTotal,
      'clienteNome': nomeCliente,
      'duracaoTotal': duracaoTotal,
      'clienteContato': contatoCliente,
      'data': Timestamp.fromDate(data),
    };
  }
}