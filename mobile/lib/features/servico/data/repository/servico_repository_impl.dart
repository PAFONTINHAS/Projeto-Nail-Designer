import 'package:mobile/features/servico/domain/entities/servico_entity.dart';
import 'package:mobile/features/servico/data/datasource/servico_remote_datasource.dart';
import 'package:mobile/features/servico/domain/repository/servico_repository.dart';

class ServicoRepositoryImpl implements ServicoRepository{

  final ServicoRemoteDatasource remoteDatasource;

  ServicoRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ServicoEntity>> getServicos() async{

    return await remoteDatasource.getServicos();
  }
  
} 