import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/features/servico/domain/entities/servico.dart';
import 'package:mobile/features/servico/domain/usecases/add_servico_usecase.dart';
import 'package:mobile/features/servico/domain/usecases/delete_servico_usecase.dart';
import 'package:mobile/features/servico/domain/usecases/get_servicos_usecase.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/servico/domain/usecases/update_servico_usecase.dart';

class ServicoController extends ChangeNotifier{

  final GetServicosUsecase _getServicosUsecase;
  final UpdateServicoUsecase _updateServicoUsecase;
  final AddServicoUsecase _addServicoUsecase;
  final DeleteServicoUsecase _deleteServicoUsecase;

  ServicoController(this._getServicosUsecase, this._addServicoUsecase, this._updateServicoUsecase, this._deleteServicoUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<String> get categorias {

    final  categoriasSet = _servicos.values.map((servico) => servico.categoria).toSet();

    final listaCategorias = categoriasSet.toList()..sort();

    return listaCategorias;
  }

  List<Servico> servicosPorCategoria(String categoria){
    return _servicos.values
      .where((servico) => servico.categoria == categoria)
      .toList();
  }

  Map<String, Servico> _servicos = {};
  Map<String, Servico> get servicos => _servicos;


  Future<void> getServicos() async{

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    final List<Servico> servicos = await _getServicosUsecase.call();

    for (final servico in servicos){
      _servicos[servico.id] = servico;
    }

    _isLoading = false;

    notifyListeners();
  }

  List<Servico> getServicosFromAgendamento(AgendamentoEntity agendamento){
    final servicos = agendamento.servicos;

    final List<Servico> infoServicos = [];

    for(final servico in servicos){

      final servicoInfo = _servicos[servico];

      if(servicoInfo != null){
        infoServicos.add(servicoInfo);
      }
    }

    return infoServicos;


  }

  Future<void> toggleServico(String id, bool status) async {
    final servicoOriginal = _servicos[id];
    if (servicoOriginal == null) return;

    // Atualização Otimista: Muda na UI antes de ir pro banco
    _servicos[id] = servicoOriginal.copyWith(servicoAtivo: status);
    notifyListeners();

    try {
      await _updateServicoUsecase.call(_servicos[id]!);
      Logger().i("Serviço ${servicoOriginal.nome} ${status ? 'ativado' : 'desativado'}");
    } catch (e) {
      // Reverte em caso de erro
      _servicos[id] = servicoOriginal;
      notifyListeners();
      _errorMessage = "Erro ao atualizar status do serviço.";
    }
  }

  Future<void> addServico(Servico servico) async{


    try{
     final updatedServico = await _addServicoUsecase.call(servico);

     if(updatedServico == null) return;

     _servicos[updatedServico.id] = updatedServico;

     notifyListeners();

    }catch(e){
      _errorMessage = "Erro ao adicionar servico";
    }

  }

  Future<void> updateServico(Servico servico) async{
    try{
      await _updateServicoUsecase.call(servico);

      _servicos[servico.id] = servico;

      notifyListeners();
    } catch(e){
      _errorMessage = "Erro ao atualizar serviço";
    }
  }

  Future<void> removeServico(String id) async{
    try{
      await _deleteServicoUsecase.call(id);

      _servicos.remove(id);

      notifyListeners();
    } catch(e){
      _errorMessage = "Erro ao deletar serviço";
    }
  }


}
