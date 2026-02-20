import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:mobile/features/servico/domain/usecases/add_servico_usecase.dart';
import 'package:mobile/features/servico/domain/usecases/get_servicos_usecase.dart';
import 'package:mobile/features/servico/domain/repository/servico_repository.dart';
import 'package:mobile/features/servico/domain/usecases/update_servico_usecase.dart';
import 'package:mobile/features/servico/domain/usecases/delete_servico_usecase.dart';
import 'package:mobile/features/servico/data/repository/servico_repository_impl.dart';
import 'package:mobile/features/servico/data/datasource/servico_remote_datasource.dart';
import 'package:mobile/features/servico/presentation/controllers/servico_controller.dart';
import 'package:mobile/features/servico/data/datasource/servico_remote_datasource_impl.dart';
import 'package:mobile/features/servico/presentation/controllers/add_or_edit_servico_controller.dart';

class ServicoProvider {

  ServicoProvider._();

  static final ServicoRemoteDatasource remoteDatasource = ServicoRemoteDatasourceImpl();
  static final ServicoRepository repository = ServicoRepositoryImpl(remoteDatasource: remoteDatasource);

  static final GetServicosUsecase getServicosUsecase = GetServicosUsecase(repository: repository);
  static final AddServicoUsecase addServicoUsecase = AddServicoUsecase(repository);
  static final UpdateServicoUsecase updateServicoUsecase = UpdateServicoUsecase(repository);
  static final DeleteServicoUsecase deleteServicoUsecase = DeleteServicoUsecase(repository);

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => ServicoController(getServicosUsecase, addServicoUsecase, updateServicoUsecase, deleteServicoUsecase)),
    ChangeNotifierProvider(create: (_) => AddOrEditServicoController())
  ];
}