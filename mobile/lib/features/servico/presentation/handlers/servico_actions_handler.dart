import 'package:flutter/material.dart';
import 'package:mobile/features/servico/presentation/handlers/servico_actions/handle_add_servico.dart';
import 'package:mobile/features/servico/presentation/handlers/servico_actions/handle_update_servico.dart';

class ServicoActionsHandler {

  ServicoActionsHandler._();

  static Future<void> handleAddServico(BuildContext context) async{
    return await HandleAddServico.call(context);
  }

  static Future<void> handleUpdateServico(BuildContext context) async{
    return await HandleUpdateServico.call(context);
  }

}