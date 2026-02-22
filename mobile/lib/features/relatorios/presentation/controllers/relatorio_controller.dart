import 'package:flutter/material.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';
import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:mobile/features/relatorios/domain/usecases/get_relatorios_mensais_usecase.dart';

class RelatorioController extends ChangeNotifier{
  
  final GetRelatoriosMensaisUsecase _getRelatoriosMensaisUsecase;

  RelatorioController(this._getRelatoriosMensaisUsecase);

  Map<String, RelatorioMensal> relatorios = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getRelatorios() async{

    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try{
      final fetchedRelatorios = await _getRelatoriosMensaisUsecase.call();

      relatorios = fetchedRelatorios;
    } catch(e){

      _errorMessage = "Erro ao pegar relatórios";
      logger.e("Erro ao pegar relatórios: $e");

    }

    _isLoading = false;
    notifyListeners();
  }


}