import 'package:flutter/widgets.dart';
import 'package:mobile/features/servico/presentation/controllers/add_or_edit_servico_controller.dart';
import 'package:mobile/features/servico/presentation/controllers/servico_controller.dart';
import 'package:provider/provider.dart';

class HandleAddServico {
  HandleAddServico ._();

  static Future<void> call(BuildContext context) async{

    final controller = context.read<ServicoController>();
    final formController = context.read<AddOrEditServicoController>();

    final servico = formController.buildNewServico();

    await controller.addServico(servico);

  }
}