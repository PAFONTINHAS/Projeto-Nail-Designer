import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/domain/usecases/listen_agendamentos_usecase.dart';

class AgendamentoController extends ChangeNotifier{

  final ListenAgendamentosUsecase _listenAgendamentosUsecase;

  AgendamentoController(this._listenAgendamentosUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StreamSubscription? _agendamentosSubscription;

  DateTime _dataVisualizada = DateTime.now();
  DateTime get dataVisualizada => _dataVisualizada;

  List<AgendamentoEntity> get agendamentosDataSelecionada{
    final String dateKey = _formatDateKey(_dataVisualizada);

    return _agendamentosPorDia[dateKey] ?? [];
  }

  void setDataVisualizada(DateTime novaData){
    _dataVisualizada = novaData;
    notifyListeners();
  }

  String _formatDateKey(DateTime data) => "${data.day}/${data.month}/${data.year}";

  List<AgendamentoEntity> get agendamentosDoDia{

    final today = _formatDateKey(DateTime.now());

    final List<AgendamentoEntity>? agendamentosDoDia = _agendamentosPorDia[today];

    return agendamentosDoDia ?? [];

  }

  Map<String, List<AgendamentoEntity>> _agendamentosPorDia = {};
  

  Future<void> listenAgendamentos() async{
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    _agendamentosSubscription?.cancel();

    _agendamentosSubscription = _listenAgendamentosUsecase.call().listen(
      (agendamentos){

        final Map<String,List<AgendamentoEntity>> novoMap = {};
        
        for (final agendamento in agendamentos) {

          final agendamentoData = _formatDateKey(agendamento.data);

          novoMap.putIfAbsent(agendamentoData, () => []).add(agendamento);
        }

        _agendamentosPorDia = novoMap;

        notifyListeners();
      }, 
      onError: (error){
        _errorMessage = "Erro ao carregar agendamentos: ${error.toString()}";
      }
    );
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _agendamentosSubscription?.cancel();
    super.dispose();
  }
  
}