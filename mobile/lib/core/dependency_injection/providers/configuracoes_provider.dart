import 'package:mobile/features/configuracoes/data/datasource/configuracoes_remote_datasource.dart';
import 'package:mobile/features/configuracoes/data/datasource/configuracoes_remote_datasource_impl.dart';
import 'package:mobile/features/configuracoes/data/repository/configuracoes_repository_impl.dart';
import 'package:mobile/features/configuracoes/domain/repository/configuracoes_repository.dart';
import 'package:mobile/features/configuracoes/domain/usecases/get_agenda_usecase.dart';
import 'package:mobile/features/configuracoes/domain/usecases/update_agenda_usecase.dart';
import 'package:mobile/features/configuracoes/presentation/controllers/configuracoes_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ConfiguracoesProvider {
  ConfiguracoesProvider._();

  static final ConfiguracoesRemoteDatasource configuracoesRemoteDatasource = ConfiguracoesRemoteDatasourceImpl();
  static final ConfiguracoesRepository configuracoesRepository = ConfiguracoesRepositoryImpl(configuracoesRemoteDatasource);
  static final GetAgendaUsecase getAgendaUsecase = GetAgendaUsecase(configuracoesRepository);
  static final UpdateAgendaUsecase updateAgendaUsecase = UpdateAgendaUsecase(configuracoesRepository);

  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => ConfiguracoesController(getAgendaUsecase, updateAgendaUsecase))
  ];
}