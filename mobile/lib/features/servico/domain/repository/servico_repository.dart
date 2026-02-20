import 'package:mobile/features/servico/domain/entities/servico.dart';

abstract class ServicoRepository {

  Future<List<Servico>> getServicos();
  Future<Servico?> addServico(Servico servico);
  Future<void> updateServico(Servico servico);
  Future<void> deleteServico(String id);


}