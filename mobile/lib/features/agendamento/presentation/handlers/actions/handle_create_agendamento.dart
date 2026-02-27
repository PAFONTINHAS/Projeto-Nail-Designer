import 'package:flutter/material.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_controller.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_fields_controller.dart';
import 'package:provider/provider.dart';

class HandleCreateAgendamento {
  HandleCreateAgendamento ._();

  static Future<void> call(BuildContext context) async{

    final agendamentoFieldsController = context.read<AgendamentoFieldsController>();
    final agendamentoController = context.read<AgendamentoController>();

    final createdAgendamento = agendamentoFieldsController.buildNewAgendamento(context);

    if(createdAgendamento == null) return;

    logger.i(createdAgendamento.toMap());

    if(createdAgendamento.nomeCliente.isEmpty) return agendamentoFieldsController.mostrarFeedback(context, "O nome não pode ser vazio", Colors.red);
    if(createdAgendamento.contatoCliente.isEmpty) return agendamentoFieldsController.mostrarFeedback(context, "O contato não pode ser vazio", Colors.red);
    // if(createdAgendamento.duracaoTotal == 0) return agendamentoFieldsController.mostrarFeedback(context, "", Colors.red);
    // if(createdAgendamento.valorTotal == 0) return agendamentoFieldsController.mostrarFeedback(context, "não pode ser nulo", Colors.red);
    if(createdAgendamento.servicos.isEmpty) return agendamentoFieldsController.mostrarFeedback(context, "Selecione ao menos 1 serviço", Colors.red);

    await agendamentoController.createAgendamento(createdAgendamento);

    if(!context.mounted) return;


    if(agendamentoController.errorMessage == null){
      agendamentoFieldsController.mostrarFeedback(context, "Agendamento criado com sucesso!", Colors.green);
    }

    agendamentoFieldsController.clearForm();

    Navigator.of(context).pop();







  }
}