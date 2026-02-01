import 'package:mobile/features/agendamento/data/datasource/agendamento_remote_datasource.dart';
import 'package:mobile/features/agendamento/data/datasource/agendamento_remote_datasource_impl.dart';
import 'package:mobile/features/agendamento/data/repository/agendamento_repository_impl.dart';
import 'package:mobile/features/agendamento/domain/repository/agendamento_repository.dart';
import 'package:mobile/features/agendamento/domain/usecases/listen_agendamentos_usecase.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_controller.dart';
import  'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class AgendamentoProvider {

  AgendamentoProvider ._();

  static final AgendamentoRemoteDatasource remoteDatasource = AgendamentoRemoteDatasourceImpl();
  static final AgendamentoRepository repository = AgendamentoRepositoryImpl(remoteDatasource: remoteDatasource);

  static final ListenAgendamentosUsecase listenAgendamentosUsecase = ListenAgendamentosUsecase(repository: repository);

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => AgendamentoController(listenAgendamentosUsecase))
  ];

}