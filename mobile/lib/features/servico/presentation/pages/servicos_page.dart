// servicos_page.dart
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/servico/domain/entities/servico.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:mobile/features/servico/presentation/controllers/servico_controller.dart';
import 'package:mobile/features/servico/presentation/handlers/servico_actions_handler.dart';
import 'package:mobile/features/servico/presentation/controllers/add_or_edit_servico_controller.dart';

class ServicosPage extends StatelessWidget {
  const ServicosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ServicoController>();
    final categorias = controller.categorias;

    return Consumer<ServicoController>(
      builder: (context, controller, child) {
      return DefaultTabController(
        length: categorias.length,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            title: const Text("Serviços", style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Color(0xFFEC489A), size: 28),
                onPressed: () => _abrirModalServico(context),
              )
            ],
            bottom: TabBar(
              isScrollable: true, // Permite rolar as abas se houver muitas categorias
              indicatorColor: const Color(0xFFEC489A),
              labelColor: const Color(0xFFEC489A),
              unselectedLabelColor: Colors.grey,
              tabs: categorias.map((cat) => Tab(text: cat)).toList(),
            ),
          ),
          body: TabBarView(
            children: categorias.map((cat) {
              final servicos = controller.servicosPorCategoria(cat);
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: servicos.length,
                itemBuilder: (context, index) => _buildServicoItem(context, servicos[index], controller),
              );
            }).toList(),
          ),
        ),
      );
      },
    );

  }

  Widget _buildServicoItem(BuildContext context, Servico servico, ServicoController controller) {
    final precoFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(servico.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("${precoFormatter.format(servico.preco)} • ${servico.duracao} min", style: TextStyle(color: Colors.grey[600])),
        trailing: Switch(
          value: servico.servicoAtivo,
          activeThumbColor: const Color(0xFFEC489A),
          onChanged: (val) => controller.toggleServico(servico.id, val),
        ),
        onTap: () => _abrirModalServico(context, servico: servico),
      ),
    );
  }

  void _confirmarFinalizacao(BuildContext context, Servico servico) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Deseja deletar esse serviço?"),
        content: Text(
          "Esse serviço não aparecerá mais para você. Se quiser apenas desativar temporariamente, clique no botão ao lado do serviço",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ServicoController>().removeServico(servico.id);

              Navigator.pop(context);
              Navigator.pop(context);
              
            },
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  void _abrirModalServico(BuildContext context, {Servico? servico}) {
    final controller = context.read<AddOrEditServicoController>();
    controller.clearFields();

    if(servico != null){
      controller.initializeForEdit(servico);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true, // Resolve o problema da barra de navegação
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => StatefulBuilder( // Necessário para o Dropdown mudar de valor no modal
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            left: 25, right: 25, top: 15,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(servico == null ? "Novo Serviço" : "Editar Procedimento", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  
                 if(servico != null)
                    IconButton(
                      onPressed: () => _confirmarFinalizacao(context, servico),
                      icon: Icon(Icons.delete_forever_outlined),
                      color: Colors.pink,
                    ),
                  
                ],
              ),
              const SizedBox(height: 25),
              
              _buildFieldLabel("Nome do Serviço"),
              TextField(
                controller: controller.nomeServico,
                decoration: _modalInputStyle("Ex: Banho de Gel"),
                onChanged: (value) => controller.setNomeServico(value),
              ),
              
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("Preço (R\$)"),
                        TextField(
                          controller: controller.preco,
                          keyboardType: TextInputType.number,
                          decoration: _modalInputStyle("0,00"),
                          onChanged: (value) => controller.setPreco(value),
                          inputFormatters: [
                            CurrencyTextInputFormatter.currency(
                              locale: 'PT_BR',
                              decimalDigits: 2,
                              symbol: 'R\$',
                              turnOffGrouping: true,
                              enableNegative: false,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel("Duração (min)"),
                        TextField(
                          controller: controller.duracao,
                          keyboardType: TextInputType.number,
                          decoration: _modalInputStyle("60"),
                          onChanged: (value) => controller.setDuracao(value),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              _buildFieldLabel("Categoria"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.categoria.text,
                    isExpanded: true,
                    items: ["Alongamento", "Manutencao", "Extras"].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (newValue) {
                      setModalState(() => controller.setCategoria(newValue!));
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 35),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC489A),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  // Aqui você monta o objeto Servico e chama o controller.salvarServico()
                  bool isEditing = controller.servicoToEdit != null;

                  controller.convertPrecoTextToDouble();

                  isEditing ? ServicoActionsHandler.handleUpdateServico(context) : ServicoActionsHandler.handleAddServico(context);

                  Navigator.pop(context);
                },
                child: const Text("Confirmar e Salvar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),

            ],
          ),
        ),
      ),
    );



}

// Helpers para manter o código limpo
Widget _buildFieldLabel(String label) => Padding(
  padding: const EdgeInsets.only(bottom: 8, left: 4),
  child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54, fontSize: 13)),
);

InputDecoration _modalInputStyle(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: TextStyle(color: Colors.grey),
  filled: true,
  fillColor: Colors.grey[300],
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
);
}