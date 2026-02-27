import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_controller.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_fields_controller.dart';
import 'package:mobile/features/agendamento/presentation/handlers/agendamento_actions_handler.dart';
import 'package:mobile/features/servico/domain/entities/servico.dart';
import 'package:provider/provider.dart';

class AgendamentoPage extends StatelessWidget {
  const AgendamentoPage({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      top: false, left: false, right: false, 
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA), // Fundo leve para destacar os cards
        appBar: AppBar(
          title: const Text("Novo Agendamento", style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildSectionHeader("Informações da Cliente", Icons.person_outline),
              const ClienteInfoCard(),
              
              const SizedBox(height: 25),
              _buildSectionHeader("Serviços", Icons.brush_outlined),
              const CategoriaSelector(),
              const SizedBox(height: 12),
              const ServicosSelection(),
              
              const SizedBox(height: 25),
              _buildSectionHeader("Data e Horário", Icons.calendar_today_outlined),
              const AgendamentoCalendar(),
              
              const SizedBox(height: 30),
              const CalculatedSummary(),
              const SizedBox(height: 120), // Espaço extra para o botão fixo
            ],
          ),
        ),
        // BOTÃO FIXO NO RODAPÉ: A melhor UX para telas de scroll
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC489A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
              ),
              onPressed: () => AgendamentoActionsHandler.handleCreateAgendamento(context),
              child: const Text(
                "CONFIRMAR NA AGENDA", 
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)
              ),
            ),
          ),
        ),
      )
    );
    
   
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFFEC489A)),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }
}


class CategoriaSelector extends StatelessWidget {
  const CategoriaSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AgendamentoFieldsController>();
    final categorias = ["Alongamento", "Manutencao", "Extras"];

    return SizedBox(
      height: 45,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final cat = categorias[index];
          final isSelected = controller.categoriaAtiva == cat;
          
          return ChoiceChip(
            label: Text(cat == "Manutencao" ? "Manutenção" : cat),
            selected: isSelected,
            onSelected: (_) => controller.setCategoriaAtiva(cat),
            selectedColor: const Color(0xFFEC489A),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey[300]!),
          );
        },
      ),
    );
  }
}

class ClienteInfoCard extends StatelessWidget {
  const ClienteInfoCard({super.key});


  @override
  Widget build(BuildContext context) {
    final phoneMaskFormatter = MaskTextInputFormatter(
      mask: "(##) #####-####",
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy
    );

    final controller = context.read<AgendamentoFieldsController>();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller.nameController,
            decoration: _inputStyle("Nome da Cliente", Icons.person_outline),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: controller.phoneController,
            keyboardType: TextInputType.number,
            inputFormatters: [phoneMaskFormatter],
            decoration: _inputStyle("WhatsApp / Celular", Icons.phone_outlined),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF1F3F5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
    );
  }
}



























class ServicosSelection extends StatelessWidget {
  const ServicosSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AgendamentoFieldsController>();
    
    return Container(
      width: double.infinity,
      // 1. Definimos uma altura máxima para a seção não crescer infinitamente
      constraints: const BoxConstraints(maxHeight: 250), 
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      // 2. Usamos o SingleChildScrollView interno para os chips
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: controller.servicosDisponiveis.map((servico) {
            final isSelected = controller.selecionados.contains(servico);
            return FilterChip(
              label: Text("${servico.nome} (${servico.duracao}min)"),
              selected: isSelected,
              onSelected: (val) => val 
                  ? controller.addServico(servico, context) 
                  : controller.removeServico(servico, context),
              selectedColor: const Color(0xFFEC489A).withOpacity(0.2),
              checkmarkColor: const Color(0xFFEC489A),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFFEC489A) : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CalculatedSummary extends StatelessWidget {
  const CalculatedSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AgendamentoFieldsController>();
    final precoFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink[50]!, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEC489A).withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem(Icons.history_toggle_off, "Duração", "${controller.tempoTotal} min"),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildSummaryItem(Icons.payments_outlined, "Total", precoFormatter.format(controller.valorTotal), isGreen: true),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String label, String value, {bool isGreen = false}) {
    return Column(
      children: [
        Icon(icon, color: isGreen ? Colors.green : const Color(0xFFEC489A), size: 22),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class AgendamentoCalendar extends StatelessWidget {
  const AgendamentoCalendar({super.key});

  @override
Widget build(BuildContext context) {
    final controller = context.watch<AgendamentoFieldsController>();
    final agendamentoController = context.read<AgendamentoController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListTile(
            onTap: () => _selecionarData(context, controller, agendamentoController),
            leading: const Icon(Icons.event, color: Color(0xFFEC489A)),
            title: Text(
              DateFormat('EEEE, dd MMMM', 'pt_BR').format(controller.dataSelecionada),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ),
          if (controller.isDayBlocked)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text("🔒 Studio fechado nesta data", style: TextStyle(color: Colors.redAccent)),
            )
          else ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: controller.gerarGradeHorarios.map((slot) {
                  final isSelected = controller.isNoIntervalo(slot.hora);
                  final canSelect = !slot.ocupado && slot.disponivelPelaDuracao;

                  return ChoiceChip(
                    label: Text(slot.hora),
                    selected: isSelected,
                    onSelected: canSelect ? (val) => controller.setHorarioSelecionado(val ? slot.hora : null) : null,
                    selectedColor: const Color(0xFFEC489A),
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    disabledColor: Colors.grey[100],
                  );
                }).toList(),
              ),
            ),
          ]
        ],
      ),
    );
  }

  Future<void> _selecionarData(
    BuildContext context,
    AgendamentoFieldsController controller,
    AgendamentoController agendamentoController,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: controller.dataSelecionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final dateString = agendamentoController.formatDateKey(date);
      controller.setDataSelecionada(date);
      controller.setAgendamentosDoDia(
        agendamentoController.agendamentosPorDia[dateString] ?? [],
      );
    }
  }
}
