import 'package:mobile/features/configuracoes/domain/entities/agenda.dart';

abstract class ConfiguracoesRemoteDatasource {

  Future<void> updateAgenda(Agenda agenda);
  Future<Agenda?> getAgenda();

}