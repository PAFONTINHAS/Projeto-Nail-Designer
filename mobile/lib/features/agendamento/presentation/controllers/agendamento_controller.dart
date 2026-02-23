import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/domain/usecases/atualizar_status_usecase.dart';
import 'package:mobile/features/agendamento/domain/usecases/get_agendamentos_from_month_usecase.dart';
import 'package:mobile/features/agendamento/domain/usecases/listen_agendamentos_usecase.dart';

class AgendamentoController extends ChangeNotifier{

  final AtualizarStatusUsecase _atualizarStatusUsecase;
  final ListenAgendamentosUsecase _listenAgendamentosUsecase;
  final GetAgendamentosFromMonthUsecase _getAgendamentosFromMonthUsecase;

  AgendamentoController(this._listenAgendamentosUsecase, this._atualizarStatusUsecase, this._getAgendamentosFromMonthUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  StreamSubscription? _agendamentosSubscription;

  DateTime _dataVisualizada = DateTime.now();
  DateTime get dataVisualizada => _dataVisualizada;

  List<AgendamentoEntity> get agendamentosDataSelecionada{
    final String dateKey = _formatDateKey(_dataVisualizada);
    final lista = _agendamentosPorDia[dateKey] ?? [];
    return lista.where((a) => a.status == 'agendado').toList();
  }

  List<AgendamentoEntity> get agendamentosAtrasados {
    final agora = DateTime.now();

    return agendamentos
        .where(
          (a) =>
              a.data.isBefore(agora) &&
              a.status == 'agendado'
        )
        .toList();
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

  List<AgendamentoEntity> get agendamentos{

    return _agendamentosPorDia.values.expand((agendamento) => agendamento).toList();
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

        _isLoading = false;
        notifyListeners();
      }, 
      onError: (error){
        _errorMessage = "Erro ao carregar agendamentos: ${error.toString()}";
      }
    );
  }

  Future<List<AgendamentoEntity>> getAgendamentosFromMonth(int year, int month) async{
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      final agendamentos = await _getAgendamentosFromMonthUsecase.call(year, month);

      return agendamentos;
    }catch(e){
      logger.e(e);
      _errorMessage = "Erro ao pegar agendamentos: $e";

      return [];
    }finally{
      _isLoading = false;
      notifyListeners();
    }


  }

  Future<void> atualizarStatus(String id, String status) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _atualizarStatusUsecase.call(id, status);
      
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _agendamentosSubscription?.cancel();
    super.dispose();
  }
  
}