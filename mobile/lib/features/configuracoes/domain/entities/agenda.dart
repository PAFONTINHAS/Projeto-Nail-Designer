class Agenda {
  final List<int> diasTrabalho;
  final String horarioInicio;
  final String horarioFim;
  final List<String> datasBloqueadas;
  final bool agendaAtiva;
  

  Agenda({
    required this.diasTrabalho,
    required this.horarioInicio,
    required this.horarioFim,
    required this.datasBloqueadas,
    this.agendaAtiva = true
  });

  Map<String, dynamic> toMap() => {
    'diasTrabalho': diasTrabalho,
    'horarioInicio': horarioInicio,
    'horarioFim': horarioFim,
    'agendaAtiva': agendaAtiva,
    'datasBloqueadas': datasBloqueadas
  };

  Agenda copyWith({
    List<int>? diasTrabalho,
    String? horarioInicio,
    String? horarioFim,
    List<String>? datasBloqueadas,
    bool? agendaAtiva,
  }){
    return Agenda(
      horarioFim: horarioFim ?? this.horarioFim,
      diasTrabalho: diasTrabalho ?? this.diasTrabalho,
      horarioInicio: horarioInicio ?? this.horarioInicio,
      datasBloqueadas: datasBloqueadas ?? this.datasBloqueadas,
      agendaAtiva: agendaAtiva ?? this.agendaAtiva
    );
  }
}