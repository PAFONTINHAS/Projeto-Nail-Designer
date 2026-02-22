import 'package:mobile/features/relatorios/data/datasource/relatorios_local_datasource.dart';
import 'package:mobile/features/relatorios/data/datasource/relatorios_local_datasource_impl.dart';
import 'package:mobile/features/relatorios/data/datasource/relatorios_remote_datasource.dart';
import 'package:mobile/features/relatorios/data/datasource/relatorios_remote_datasource_impl.dart';
import 'package:mobile/features/relatorios/data/repository/relatorios_repository_impl.dart';
import 'package:mobile/features/relatorios/domain/repository/relatorios_repository.dart';
import 'package:mobile/features/relatorios/domain/usecases/add_relatorio_usecase.dart';
import 'package:mobile/features/relatorios/domain/usecases/get_relatorios_mensais_usecase.dart';
import 'package:mobile/features/relatorios/presentation/controllers/relatorio_controller.dart';
import 'package:mobile/features/relatorios/presentation/controllers/relatorio_fields_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class RelatorioProvider {
  RelatorioProvider._();

  static final RelatoriosRemoteDatasource remoteDatasource = RelatoriosRemoteDatasourceImpl();
  static final RelatoriosLocalDatasource localDatasource = RelatoriosLocalDatasourceImpl();

  static final RelatoriosRepository repository = RelatoriosRepositoryImpl(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
  );

  static final GetRelatoriosMensaisUsecase getRelatoriosMensaisUsecase = GetRelatoriosMensaisUsecase(repository);
  static final AddRelatorioUsecase addRelatorioUsecase = AddRelatorioUsecase(repository);

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => RelatorioController(getRelatoriosMensaisUsecase, addRelatorioUsecase)),
    ChangeNotifierProvider(create: (_) => RelatorioFieldsController())
  ];
}