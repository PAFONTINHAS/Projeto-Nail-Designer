class Agenda {
  final List<int> diasTrabalho;
  final String horarioInicio;
  final String horarioFim;

  Agenda({
    required this.diasTrabalho,
    required this.horarioInicio,
    required this.horarioFim,
  });

  Map<String, dynamic> toMap() => {
    'diasTrabalho': diasTrabalho,
    'horarioInicio': horarioInicio,
    'horarioFim': horarioFim,
  };

  Agenda copyWith({
    List<int>? diasTrabalho,
    String? horarioInicio,
    String? horarioFim
  }){
    return Agenda(
      horarioFim: horarioFim ?? this.horarioFim,
      diasTrabalho: diasTrabalho ?? this.diasTrabalho,
      horarioInicio: horarioInicio ?? this.horarioInicio,
    );
  }
}