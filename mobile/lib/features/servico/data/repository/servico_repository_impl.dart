import 'package:mobile/features/servico/domain/entities/servico.dart';
import 'package:mobile/features/servico/data/datasource/servico_remote_datasource.dart';
import 'package:mobile/features/servico/domain/repository/servico_repository.dart';

class ServicoRepositoryImpl implements ServicoRepository{

  final ServicoRemoteDatasource remoteDatasource;

  ServicoRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Servico>> getServicos() async{

    return await remoteDatasource.getServicos();
  }
  
  @override
  Future<Servico?> addServico(Servico servico) async{

    return await remoteDatasource.addServico(servico);
  }
  
  @override
  Future<void> updateServico(Servico servico) async{

    return await remoteDatasource.updateServico(servico);
  }
  
  @override
  Future<void> deleteServico(String id) async{

    return await remoteDatasource.deleteServico(id);
  }
  
} 