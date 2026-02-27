import 'package:flutter/widgets.dart';
import 'package:mobile/features/agendamento/presentation/handlers/actions/handle_create_agendamento.dart';

class AgendamentoActionsHandler {

  AgendamentoActionsHandler ._();

  static Future<void> handleCreateAgendamento(BuildContext context) async{
    return await HandleCreateAgendamento.call(context);
  } 


}