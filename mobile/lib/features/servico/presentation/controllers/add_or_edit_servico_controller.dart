
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';
import 'package:mobile/features/servico/domain/entities/servico.dart';

class AddOrEditServicoController extends ChangeNotifier {

  final TextEditingController _nomeServico = TextEditingController();
  TextEditingController get nomeServico => _nomeServico;

  final TextEditingController _preco = TextEditingController();
  TextEditingController get preco => _preco;

  final TextEditingController _duracao = TextEditingController();
  TextEditingController get duracao => _duracao;

  final TextEditingController _categoria = TextEditingController(text: "Alongamento");
  TextEditingController get categoria => _categoria;

  Servico? _servicoToEdit;
  Servico? get  servicoToEdit => _servicoToEdit;

  double get _realPreco => convertPrecoTextToDouble();

  int get _realDuracao => int.parse(_duracao.text);

  void initializeForEdit(Servico servico){

    final precoFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    _servicoToEdit = servico;

    _nomeServico.text = servico.nome;
    _preco.text = precoFormatter.format(servico.preco);
    _duracao.text = servico.duracao.toString();
    _categoria.text = servico.categoria;

    notifyListeners();
  }

  void clearFields(){
    _nomeServico.clear();
    _preco.clear();
    _duracao.clear();
    _categoria.text = "Alongamento";
    _servicoToEdit = null;
    notifyListeners();
  }

  void setNomeServico(String value){
    _nomeServico.text = value;
    notifyListeners();
  }

  void setDuracao(String value){
    _duracao.text = value;
    notifyListeners();
  }

  void setPreco(String value){
    _preco.text = value;
    notifyListeners();
  }

  void setCategoria(String value){
    _categoria.text = value;
    notifyListeners();
  }

  Servico buildNewServico(){

    return Servico(
      id: '',
      nome: nomeServico.text.trim(),
      preco: _realPreco,
      duracao: _realDuracao,
      categoria: categoria.text,
      servicoAtivo: true
    );
  }

  Servico? buildUpdatedServico(){

    if(servicoToEdit == null) return null;

    final servico =  Servico(
      id: servicoToEdit!.id,
      nome: nomeServico.text.trim(),
      preco: _realPreco,
      duracao: _realDuracao,
      categoria: categoria.text,
      servicoAtivo: _servicoToEdit!.servicoAtivo,
    );

    logger.i(servico.toMap());

    return servico;
  }

  double convertPrecoTextToDouble(){

    String textValue = preco.text;

    String onlyNumbers = textValue.replaceAll(RegExp(r'[^0-9]'), '');
    double finalValue = double.parse(onlyNumbers) / 100;

    logger.i("Preço formatado: ${preco.text}. Preço convertido: $finalValue");

    return finalValue;
    
  }




}