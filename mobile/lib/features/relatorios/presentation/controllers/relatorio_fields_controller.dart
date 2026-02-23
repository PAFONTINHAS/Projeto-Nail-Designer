import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile/core/utils/helpers.dart';
import 'package:mobile/features/servico/domain/entities/servico.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';
import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:mobile/features/agendamento/domain/entities/agendamento_entity.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_controller.dart';


class RelatorioFieldsController extends ChangeNotifier {

  Map<String, RelatorioMensal> _historicoRelatorios = {};

  RelatorioMensal? get relatorioExibido {

    final mesFormatado = _mesReferencia.month.toString().padLeft(2, '0');

    final id = "${_mesReferencia.year}-$mesFormatado";

    return _historicoRelatorios[id];

  }

  bool get isCurrentMonth {
    final today = DateTime.now();
    return  _mesReferencia.month == today.month &&
            _mesReferencia.year == today.year;
  }

  bool get isPreviousMonth{
    final today = DateTime.now();

    return (_mesReferencia.month < today.month && _mesReferencia.year == today.year) ||
           (_mesReferencia.month == today.month && _mesReferencia.year < today.year) ||
           (_mesReferencia.month < today.month && _mesReferencia.year < today.year)  ||
           (_mesReferencia.month > today.month && _mesReferencia.year < today.year); 
  }

  double get valorPerdidoFaltas{
    return agendamentosFiltrados
      .where((a) => a.status == 'falta')
      .fold(0, (soma, a) => soma + a.valorTotal);
  }

  int get faltas{
    return agendamentosFiltrados
      .where((a) => a.status == 'falta')
      .length;
  }

  int get cancelamentos{
    return agendamentosFiltrados
      .where((a) => a.status == 'cancelado')
      .length;
  }

  DateTime _mesReferencia = DateTime.now();
  DateTime get mesReferencia => _mesReferencia;

  List<AgendamentoEntity> _todosAgendamentos = [];

  List<AgendamentoEntity> get agendamentosFiltrados{
    return _todosAgendamentos.where((a){
      return a.data.month == _mesReferencia.month &&
             a.data.year == _mesReferencia.year;
    }).toList();
  }

  Future<RelatorioMensal?> verifyAndConsolidatePreviousMonth({
    required List<AgendamentoEntity> todosAgendamentos,
    required List<Servico> todosServicos,
    required AgendamentoController agendamentoController,
  }) async{

    final agora = DateTime.now();
    final mesAnteriorDate = DateTime(agora.year, agora.month - 1, 1);
    final String idMesAnterior = "${mesAnteriorDate.year}-${mesAnteriorDate.month.toString().padLeft(2, '0')}";

    if(_historicoRelatorios.containsKey(idMesAnterior)) return null;

    final agendamentosMesAnterior = await agendamentoController.getAgendamentosFromMonth(mesAnteriorDate.year, mesAnteriorDate.month);
    final List<AgendamentoEntity> atendimentosRealizados = agendamentosMesAnterior.where((agendamento) => agendamento.status == 'finalizado').toList();

    final totalAtendimentosRealizados = atendimentosRealizados.length;


    if(agendamentosMesAnterior.isEmpty) return null;

    final double faturamentoRealizado = agendamentosMesAnterior
      .where((a) => a.status == 'finalizado')
      .fold(0, (soma, a) => soma + a.valorTotal);

    final clientesAtendidos = atendimentosRealizados
      .map((agendamento) => agendamento.contatoCliente.trim().toLowerCase())
      .toSet()
      .length;

    final faltas = agendamentosMesAnterior.where((a) => a.status == 'falta').length;
    
    final cancelados = agendamentosMesAnterior.where((a) => a.status == 'cancelado').length;

    double perda = agendamentosMesAnterior.where((a) => a.status == 'falta').fold(0, (soma, a) => soma + a.valorTotal);

    logger.i('''
      Atendimentos realizados: $totalAtendimentosRealizados
      Atendimentos finalizados: $atendimentosRealizados
      Atendimentos totais: ${agendamentosMesAnterior.map((a) => a.status == 'finalizado')}
      Clientes Atendidos: $clientesAtendidos
      Faturamento total: $faturamentoRealizado  
    ''');

    double ticketMedio = calculateTicketMedio(atendimentosRealizados);

    return RelatorioMensal(
      id: idMesAnterior,
      ticketMedio: tranformIntoOneDecimal(ticketMedio),
      clientesAtendidos: clientesAtendidos,
      totalAtendimentos: totalAtendimentosRealizados,
      faturamentoRealizado: tranformIntoOneDecimal(faturamentoRealizado),
      faturamentoPorCategoria: calcularDistribuicaoPorCategoria(todosServicos, agendamentosFromMonth: agendamentosMesAnterior),
      totalFaltas: faltas,
      totalCancelamentos: cancelados,
      valorPerdidoFaltas: perda
    );
  }
  

  double calculateTicketMedio(List<AgendamentoEntity> atendimentos){
    
    if (atendimentos.isEmpty) return 0.0;

    double totalCofre = atendimentos.fold(0, (soma, a) => soma + a.valorTotal);
    
    return totalCofre / atendimentos.length;

  }


  void changeMonth(int offset){

    _mesReferencia = DateTime(_mesReferencia.year, _mesReferencia.month + offset, 1);

    notifyListeners();
  }

  Future<void> updateRelatorios(Map<String, RelatorioMensal> relatorios) async{
    _historicoRelatorios = relatorios;
    notifyListeners();
  }

  void updateData (List<AgendamentoEntity> agendamentos){
    _todosAgendamentos = agendamentos;
    notifyListeners();
  }

  int get clientesAtendidos{

    return agendamentosFiltrados
      .map((agendamento) => agendamento.contatoCliente.trim().toLowerCase())
      .toSet()
      .length;
  }

  // --- LÓGICA DE CÁLCULO ---

  // 1. Faturamento Realizado (O que já foi finalizado)
  double get faturamentoRealizado {
    return agendamentosFiltrados
        .where((a) => a.status == 'finalizado')
        .fold(0, (soma, a) => soma + a.valorTotal);
  }

  // 2. Faturamento Previsto (O que ainda vai acontecer e não foi finalizado)
  double get faturamentoPrevisto {
    // final agora = DateTime.now();
    return agendamentosFiltrados
        .where((a) => a.status == 'agendado')
        .fold(0, (soma, a) => soma + a.valorTotal);
  }
  
  int get qtdPendentes{
    final agora = DateTime.now();

    return agendamentosFiltrados
      .where((a) => a.status == 'agendado' && a.data.isBefore(agora))
      .length;
  }

  // 3. Faturamento Total (Projeção: Tudo que entrou + Tudo que vai entrar)
  double get faturamentoTotalProjetado => faturamentoRealizado + faturamentoPrevisto;

  // 4. Ticket Médio
  double get ticketMedio {
    // Pegamos apenas quem já foi atendido (finalizado)
    final atendidos = agendamentosFiltrados.where((a) => a.status == 'finalizado').toList();
    
    if (atendidos.isEmpty) return 0.0;

    double totalCofre = atendidos.fold(0, (soma, a) => soma + a.valorTotal);
    
    return totalCofre / atendidos.length;
  }
  
  // 5. Percentual de Meta (Exemplo: Meta de R$ 5.000)
  double get percentualMeta {
    const meta = 5000.0; 
    return (faturamentoTotalProjetado / meta).clamp(0.0, 1.0);
  }

  double get faturamentoMesAnterior {

    if(isPreviousMonth || isCurrentMonth){

      final anterior = DateTime(_mesReferencia.year, _mesReferencia.month - 1, 1);
      final mesAnterior = "${anterior.year.toString()}-${anterior.month.toString().padLeft(2, '0')}";
      final relatorioMesAnterior = _historicoRelatorios[mesAnterior];

      if(relatorioMesAnterior== null) return 0.0;

      return relatorioMesAnterior.faturamentoRealizado;
    }

    final mesAnterior = DateTime(_mesReferencia.year, _mesReferencia.month - 1, 1);
    return _todosAgendamentos.where((a) {
      return a.status == 'finalizado' && 
            a.data.month == mesAnterior.month && 
            a.data.year == mesAnterior.year;
    }).fold(0.0, (soma, a) => soma + a.valorTotal);

  }

  double get crescimentoComparativo {

    final mesEscolhido = DateTime(_mesReferencia.year, _mesReferencia.month, 1);
    final mesAnterior = DateTime(mesEscolhido.year, mesEscolhido.month - 1, 1);

    final mesEscolhidoId = "${mesEscolhido.year.toString()}-${mesEscolhido.month.toString().padLeft(2, '0')}";
    final mesAnteriorId = "${mesAnterior.year.toString()}-${mesAnterior.month.toString().padLeft(2, '0')}";

    if(isPreviousMonth){
      
      final relatorioMesEscolhido = _historicoRelatorios[mesEscolhidoId];
      final relatorioMesAnterior =  _historicoRelatorios[mesAnteriorId];

      if(relatorioMesAnterior == null || relatorioMesEscolhido == null) return 1.0;

      final atual = relatorioMesEscolhido.faturamentoRealizado;
      final anterior = relatorioMesAnterior.faturamentoRealizado;

      if(anterior == 0) return atual > 0 ? 1.0 : 0.0;
      
      return (atual - anterior) / anterior;
    }


    final atual = faturamentoTotalProjetado;
    final anterior = faturamentoMesAnterior;

    if (anterior == 0) return atual > 0 ? 1.0 : 0.0;
    
    return (atual - anterior) / anterior;
  }



  Map<String, double> calcularDistribuicaoPorCategoria(List<Servico> todosOsServicosDisponiveis, {List<AgendamentoEntity>? agendamentosFromMonth}) {

    final agendamentos = agendamentosFromMonth ?? agendamentosFiltrados;
    final Map<String, double> distribuicao = {};

    for (var agendamento in agendamentos) {
      // Só contamos o que foi finalizado ou o que está previsto (depende da sua escolha)
      // Para relatórios de performance, geralmente usamos apenas os finalizados
      if (agendamento.status != 'finalizado') continue;

      for (var servicoId in agendamento.servicos) {
        // Buscamos a info do serviço para saber a categoria dele
        final servicoInfo = todosOsServicosDisponiveis.firstWhere(
          (s) => s.id == servicoId,
          orElse: () => Servico(id: '', nome: '', preco: 0, duracao: 0, categoria: 'Outros', servicoAtivo: true),
        );

        final categoria = servicoInfo.categoria;
        distribuicao[categoria] = (distribuicao[categoria] ?? 0) + servicoInfo.preco;
      }
    }
    return distribuicao;
  }

  List<PieChartSectionData> obterDadosGrafico(Map<String, double> distribuicao) {
    final List<PieChartSectionData> secoes = [];
    
    // Cores fixas para as principais categorias
    final cores = [Colors.pinkAccent, Colors.purpleAccent, Colors.blueAccent, Colors.orangeAccent];
    int corIndex = 0;

    distribuicao.forEach((categoria, valor) {
      secoes.add(
        PieChartSectionData(
          color: cores[corIndex % cores.length],
          value: valor,
          title: categoria, // Opcional: pode deixar vazio e usar legenda externa
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 12, 
            fontWeight: FontWeight.bold, 
            color: Colors.white
          ),
        ),
      );
      corIndex++;
    });

    return secoes;
  }



}