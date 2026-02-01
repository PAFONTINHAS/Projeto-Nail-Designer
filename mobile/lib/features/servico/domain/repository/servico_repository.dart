import 'package:mobile/features/servico/domain/entities/servico_entity.dart';

abstract class ServicoRepository {

  Future<List<ServicoEntity>> getServicos();

}