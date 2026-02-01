import 'package:mobile/features/servico/data/datasource/servico_remote_datasource.dart';
import 'package:mobile/features/servico/data/datasource/servico_remote_datasource_impl.dart';
import 'package:mobile/features/servico/data/repository/servico_repository_impl.dart';
import 'package:mobile/features/servico/domain/repository/servico_repository.dart';
import 'package:mobile/features/servico/domain/usecases/get_servicos_usecase.dart';
import 'package:mobile/features/servico/presentation/controllers/servico_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ServicoProvider {

  ServicoProvider._();

  static final ServicoRemoteDatasource remoteDatasource = ServicoRemoteDatasourceImpl();
  static final ServicoRepository repository = ServicoRepositoryImpl(remoteDatasource: remoteDatasource);

  static final GetServicosUsecase getServicosUsecase = GetServicosUsecase(repository: repository);

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => ServicoController(getServicosUsecase))
  ];
}