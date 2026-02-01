import 'package:flutter/foundation.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/servico/domain/entities/servico_entity.dart';
import 'package:mobile/features/servico/domain/usecases/get_servicos_usecase.dart';

class ServicoController extends ChangeNotifier{

  final GetServicosUsecase _getServicosUsecase;

  ServicoController(this._getServicosUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // List<ServicoEntity> _servicos = [];
  // List<ServicoEntity> get servicos => _servicos;

  Map<String, ServicoEntity> _servicos = {};


  Future<void> getServicos() async{

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    final List<ServicoEntity> servicos = await _getServicosUsecase.call();

    for (final servico in servicos){
      _servicos[servico.id] = servico;
    }

    _isLoading = false;

    notifyListeners();
  }

  List<ServicoEntity> getServicosFromAgendamento(AgendamentoEntity agendamento){
    final servicos = agendamento.servicos;

    final List<ServicoEntity> infoServicos = [];

    for(final servico in servicos){

      final servicoInfo = _servicos[servico];

      if(servicoInfo != null){
        infoServicos.add(servicoInfo);
      }
    }

    return infoServicos;
  

  }
}
