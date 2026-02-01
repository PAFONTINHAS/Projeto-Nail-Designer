import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/features/servico/domain/entities/servico_entity.dart';


class ServicoModel extends ServicoEntity {
  ServicoModel({
    required super.id,
    required super.nome,
    required super.preco,
    required super.duracao,
    required super.categoria,
  });

  factory ServicoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServicoModel(
      id: doc.id,
      nome: data['nome'],
      preco: (data['preco'] as int).toDouble(),
      duracao: data['duracao'],
      categoria: data['categoria'],
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