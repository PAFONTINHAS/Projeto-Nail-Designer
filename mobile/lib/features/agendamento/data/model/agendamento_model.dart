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
    required super.notificacaoEnviada
  });

  factory AgendamentoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AgendamentoModel(
      id: doc.id,
      status            : data['status'] ?? '',
      contatoCliente    : data['contato'] ?? '',
      nomeCliente       : data['clienteNome'] ?? '',
      duracaoTotal      : data['duracaoTotal'] ?? 0,
      notificacaoEnviada: data['notificacaoEnviada'] ?? false,
      data              : (data['data'] as Timestamp).toDate(),
      valorTotal        : (data['valorTotal'] as num).toDouble(),
      servicos          : List<String>.from(data['servicos'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'status': status,
      'servicos': servicos,
      'valorTotal': valorTotal,
      'clienteNome': nomeCliente,
      'duracaoTotal': duracaoTotal,
      'clienteContato': contatoCliente,
      'data': Timestamp.fromDate(data),
    };
  }
}