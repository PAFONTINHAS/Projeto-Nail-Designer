import 'package:flutter/widgets.dart';
import 'package:mobile/features/servico/presentation/controllers/add_or_edit_servico_controller.dart';
import 'package:mobile/features/servico/presentation/controllers/servico_controller.dart';
import 'package:provider/provider.dart';

class HandleUpdateServico {

  HandleUpdateServico ._();

  static Future<void> call(BuildContext context) async{

    final controller = context.read<ServicoController>();
    final formController = context.read<AddOrEditServicoController>();

    final updatedServico = formController.buildUpdatedServico();

    if (updatedServico == null) return;
    
    await controller.updateServico(updatedServico);

  }
}