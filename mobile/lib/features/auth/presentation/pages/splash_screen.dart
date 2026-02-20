import 'package:flutter/material.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_controller.dart';
import 'package:mobile/features/agenda/presentation/controllers/agenda_controller.dart';
import 'package:mobile/features/home/presentation/pages/home_page.dart';
import 'package:mobile/features/servico/presentation/controllers/servico_controller.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
      _prepareUserApp();
    }); 
  }

  Future<void> _prepareUserApp() async{

    final agendamentoController = context.read<AgendamentoController>();
    final servicoController = context.read<ServicoController>();
    final configuracoesController = context.read<ConfiguracoesController>();

    await servicoController.getServicos();
    await configuracoesController.getAgenda();
    await agendamentoController.listenAgendamentos();
    await configuracoesController.fillAgenda();


    if(!mounted) return;
    
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false
    );

  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          Text("Preparando seu aplicativo"),
        ],
      )

    ));
  }
}