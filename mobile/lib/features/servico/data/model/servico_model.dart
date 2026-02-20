import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/features/servico/domain/entities/servico.dart';


class ServicoModel extends Servico {
  ServicoModel({
    required super.id,
    required super.nome,
    required super.preco,
    required super.duracao,
    required super.categoria,
    required super.servicoAtivo,
  });

  factory ServicoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final isInt = data['preco'] is int ? true: false;
    final preco = isInt ? (data['preco'] as int).toDouble() : data['preco'];


    return ServicoModel(
      id: doc.id,
      nome: data['nome'],
      preco: preco,
      duracao: data['duracao'],
      categoria: data['categoria'],
      servicoAtivo: data['servicoAtivo'] ?? true
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'preco': preco,
      'duracao': duracao,
      'categoria': categoria,
    };
  }
}