import 'package:flutter/material.dart';
import 'package:mobile/features/agenda/domain/entities/agenda.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';
import 'package:mobile/features/servico/domain/entities/servico.dart';

class AgendamentoFieldsController extends ChangeNotifier{

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get phoneController => _phoneController;

  DateTime _dataSelecionada = DateTime.now();
  DateTime get dataSelecionada => _dataSelecionada;


  String? _horarioSelecionado = "";
  String? get horarioSelecionado => _horarioSelecionado;

  Agenda? _agenda;
  Agenda? get agenda => _agenda;

  List<Servico> _servicosDisponiveis = [];
  List<Servico> get servicosDisponiveis {
    return _servicosDisponiveis.where(
      (servico) => 
        servico.servicoAtivo && 
        servico.categoria == _categoriaAtiva
      )
      .toList();
  }

  bool get isDayBlocked{

    if(agenda == null) return true;

    final dateString = "${_dataSelecionada.day.toString().padLeft(2, '0')}/${_dataSelecionada.month.toString().padLeft(2, '0')}/${_dataSelecionada.year}";

    logger.i(dateString);

    for(final blockedDay in agenda!.datasBloqueadas ){
      if(dateString == blockedDay){
        return true;
      }
    }

    if(agenda!.diasTrabalho.contains(_dataSelecionada.weekday)){
      return true;
    }

    if(_dataSelecionada.weekday == 7 && agenda!.diasTrabalho.contains(0)){
      return true;
    }

    return false;
  }

  String _categoriaAtiva = "Alongamento";
  String get categoriaAtiva => _categoriaAtiva;

  int get tempoTotal {
    return selecionados.fold(0, (sum, item) => sum + item.duracao);
  }

  double get valorTotal{
    return selecionados.fold(0.0, (sum, item) => sum + item.preco);
  }

  List<Servico> _selecionados = [];
  List<Servico> get selecionados => _selecionados;
  

  void setDataSelecionada(DateTime novaData){
    _dataSelecionada = novaData;

    notifyListeners();
  }

  void setAgenda(Agenda agenda){
    _agenda = agenda;
  }


  void setCategoriaAtiva(String categoria){

    _categoriaAtiva = categoria;
    notifyListeners();
  }

  setServicosDisponiveis(List<Servico> servicos){

    _servicosDisponiveis = servicos;
    notifyListeners();
  }
  
  void addServico(Servico servico){
    
    _selecionados = List.from(_selecionados)..add(servico);
    
    notifyListeners();
  }

  void removeServico(Servico servico){
    _selecionados = List.from(_selecionados)..remove(servico);
    notifyListeners();
  }

  void setName(String name){
    _nameController.text = name;
    notifyListeners();
  }

  void setPhone(String phone){
    _phoneController.text = phone;
    notifyListeners();
  }

  void setHorarioSelecionado(String? horario){
    _horarioSelecionado = horario;
    notifyListeners();
  }

  List<String> get horariosVagos{
    return ["08:00", "08:30", "09:00", "10:30", "14:00", "15:30"];
  }



}