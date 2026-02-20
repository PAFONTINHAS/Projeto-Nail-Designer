import 'package:flutter/material.dart';
import 'package:mobile/features/agenda/presentation/handlers/agenda_actions/handle_update_agenda.dart';

class AgendaActionsHandler {

  AgendaActionsHandler ._();

  static Future<void> handleUpdateAgenda(BuildContext context)  async{
    await HandleUpdateAgenda.call(context);
  }
}