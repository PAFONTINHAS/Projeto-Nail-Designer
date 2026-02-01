import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/servico/domain/entities/servico_entity.dart';

abstract class ServicoRemoteDatasource {

  Future<List<ServicoEntity>> getServicos();
  
}