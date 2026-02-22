import 'package:mobile/core/dependency_injection/providers/agendamento_provider.dart';
import 'package:mobile/core/dependency_injection/providers/configuracoes_provider.dart';
import 'package:mobile/core/dependency_injection/providers/relatorio_provider.dart';
import 'package:mobile/core/dependency_injection/providers/servico_provider.dart';
import 'package:provider/single_child_widget.dart';

class DependencyInjection {

  late final List<SingleChildWidget> providers;

  DependencyInjection(){
    _buildProviders();
  }
  
  void _buildProviders(){
    providers = [
      ...AgendamentoProvider.providers,
      ...ServicoProvider.providers,
      ...ConfiguracoesProvider.providers,
      ...RelatorioProvider.providers
    ];
  }
  
}