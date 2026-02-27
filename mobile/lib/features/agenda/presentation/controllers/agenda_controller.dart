import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mobile/features/agenda/domain/entities/agenda.dart';
import 'package:mobile/features/agenda/domain/usecases/get_agenda_usecase.dart';
import 'package:mobile/features/agenda/domain/usecases/update_agenda_usecase.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';

class ConfiguracoesController extends ChangeNotifier{

  final GetAgendaUsecase _getAgendaUsecase;
  final UpdateAgendaUsecase _updateAgendaUsecase;

  ConfiguracoesController(this._getAgendaUsecase,  this._updateAgendaUsecase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  Agenda? _agenda;
  Agenda? get agenda => _agenda;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  
  String _horarioInicio = "";
  String get horarioInicio => _horarioInicio;
  
  String _horarioFim = "";
  String get horarioFim => _horarioFim;

  List<int> _selecionados  = [];
  List<int> get selecionados => _selecionados;

  List<String> _datasBloqueadas = [];
  List<String> get datasBloqueadas => _datasBloqueadas;

  bool _agendaAtiva = true;
  bool get agendaAtiva => _agendaAtiva;

  bool get haveAgendaChanged => verifyAgendaChanges();

  Future<void> fillAgenda() async{
    _selecionados = agenda?.diasTrabalho ?? [];
    _horarioInicio = agenda?.horarioInicio ?? _horarioInicio;
    _horarioFim = agenda?.horarioFim ?? _horarioFim;
    _datasBloqueadas = agenda?.datasBloqueadas ?? _datasBloqueadas;
    _agendaAtiva = agenda?.agendaAtiva ?? _agendaAtiva;

    notifyListeners();
  }

  bool verifyAgendaChanges(){

    if (agenda == null) return true;

    if(_agendaAtiva != agenda!.agendaAtiva){
      return true;
    }


    // for(final dia in agenda!.diasTrabalho){
    //   if(_selecionados.isNotEmpty && !_selecionados.contains(dia)){
    //     return true;
    //   }
    // }

    // for(int i = 0; i <= agenda!.diasTrabalho.length; i++){
      
    //   if(_selecionados.isEmpty) break;
    //   logger.i("Dia selecionado: ${_selecionados[i]}");
    //   if(_selecionados[i] != agenda!.diasTrabalho[i]){
    //     return true;
    //   }
    // }

    if(_horarioInicio != agenda!.horarioInicio){
      return true;
    }

    if(_horarioFim != agenda!.horarioFim){
      return true;
    }

    for(int i = 0; i < agenda!.datasBloqueadas.length; i++){
      if(_datasBloqueadas[i] != agenda!.datasBloqueadas[i]){
        return true;
      }
    }

    return false;
  }

  void orderDiasSelecionados(){
    
    if(_selecionados.isEmpty) return;
  
    _selecionados.sort();
  }
  
  void setHorarioInicio (String novoHorario){
    _horarioInicio = novoHorario;
    Logger().i("Horário selecionado: $_horarioInicio");
    notifyListeners();
  }

  void setHorarioFim (String novoHorario){
    _horarioFim = novoHorario;
    Logger().i("Horário selecionado: $_horarioFim");
    notifyListeners();
  }

  void addDiaSelecionado(int novoDia){
    _selecionados = List.from(_selecionados)..add(novoDia);

    orderDiasSelecionados();
    notifyListeners();
  }

  void removeDiaSelecionado(int dia){
    _selecionados = List.from(_selecionados)..removeWhere((diaAntigo) => dia == diaAntigo);
    
    orderDiasSelecionados();
    notifyListeners();
  }

  void toggleAgendaAtiva(bool value){
    _agendaAtiva = value;
    notifyListeners();
  }

  void addDataBloqueada(DateTime date){

    List<String> updatedDates = List.from(_datasBloqueadas);

    String dataFormatada = date.toIso8601String().split('T')[0];

    if(!_datasBloqueadas.contains(dataFormatada)){
      
      updatedDates.add(dataFormatada);
    }

    updatedDates.sort();

    _datasBloqueadas = updatedDates;
    notifyListeners();
  }

  void removeDataBloqueada(String date){
    List<String> updatedDates = List.from(_datasBloqueadas);

    updatedDates.remove(date);

    _datasBloqueadas = updatedDates;

    notifyListeners();

  }

  Future<void> getAgenda() async{

    final fetchedAgenda = await _getAgendaUsecase.call();

    _agenda = fetchedAgenda;

    notifyListeners();

  }


  Future<Agenda> buildUpdatedAgenda() async{
    
    return Agenda(
      diasTrabalho: _selecionados,
      horarioInicio: _horarioInicio,
      horarioFim: _horarioFim,
      datasBloqueadas: datasBloqueadas,
      agendaAtiva: agendaAtiva,
    );
  }  

  void locallyUpdateAgenda(Agenda updatedAgenda){

    _agenda = updatedAgenda;
    notifyListeners();
  }

  Future<void> updateAgenda(Agenda agenda, BuildContext context) async{

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try{
      await _updateAgendaUsecase.call(agenda);

      locallyUpdateAgenda(agenda);

      if(context.mounted){
        _mostrarFeedback(context, "Configurações salvas com sucesso! 💅", Colors.green);
      }
    } catch (e) {
    _errorMessage = "Erro ao salvar: $e";
    if (context.mounted) {
      _mostrarFeedback(context, "Erro ao salvar configurações", Colors.red);
    }
  } finally {
    _isLoading = false;
    notifyListeners();
  }
  }

}

void _mostrarFeedback(BuildContext context, String mensagem, Color cor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensagem, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: cor,
      behavior: SnackBarBehavior.floating, // Dá um ar mais moderno/mobile
      duration: const Duration(seconds: 2),
    ),
  );
}