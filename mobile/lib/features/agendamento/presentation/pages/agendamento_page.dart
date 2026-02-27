import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/features/servico/domain/entities/servico.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';
import 'package:mobile/features/agendamento/presentation/controllers/agendamento_fields_controller.dart';

class AgendamentoPage extends StatelessWidget {
  const AgendamentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final controller = context.read<AgendamentoFieldsController>();
    final phoneMaskFormatter = MaskTextInputFormatter(
      mask: "(##) #####-####",
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy
    );

    return SafeArea(
      top: false, left: false, right: false,
      child: 
  
      Scaffold(
        appBar: AppBar(
          title: Text("Novo agendamento"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Informações da Cliente"),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Nome da Cliente",
                        prefixIcon: Icon(Icons.person),
                      ),
                      controller: controller.nameController,
                      onChanged: (value) => controller.setName(value),
                    ),
                    SizedBox(height: 10),

                    TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [phoneMaskFormatter],
                      decoration: InputDecoration(
                        labelText: "WhatsApp",
                        prefixIcon: Icon(Icons.phone),
                      ),
                      controller: controller.phoneController,
                      onChanged: (value) => controller.setPhone(value),
                    ),
                  ],
                ),
              ),
            ),

            Text("Serviços Selecionados"),
            Selector<AgendamentoFieldsController, String>(
              selector: (_, controller) => controller.categoriaAtiva,
              builder: (context, value, child) {
                return Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: Text("Alongamento"),
                      selected: controller.categoriaAtiva == "Alongamento",
                      onSelected: (_) => controller.setCategoriaAtiva("Alongamento"),
                    ),
                    FilterChip(
                      label: Text("Manutenção"),
                      selected: controller.categoriaAtiva == "Manutencao",
                      onSelected: (_) => controller.setCategoriaAtiva("Manutencao"),
                    ),
                    FilterChip(
                      label: Text("Extras"),
                      selected: controller.categoriaAtiva == "Extras",
                      onSelected: (_) => controller.setCategoriaAtiva("Extras"),
                    ),
                  ],
                );
              },
            ),

            Text("Informações da Cliente"),


            Selector<AgendamentoFieldsController, List<Servico>>(
              selector: (_, controller) => controller.servicosDisponiveis,
              builder: (context, value, child) => ServicosSelection(),
            ),

            const AgendamentoCalendar(),

            const CalculatedSummary(),


            // BOTÃO FINALIZAR
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 18)),
                onPressed: () {logger.i("Telefone: ${controller.phoneController.text}");}, 
                child: Text("SALVAR NA AGENDA"),
              ),
            )
          ],
        ),
      )
    );
  }  
}

class ServicosSelection extends StatelessWidget {
  const ServicosSelection({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = context.read<AgendamentoFieldsController>();
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Selector<AgendamentoFieldsController, List<Servico>>(
        selector: (_, controller) => controller.selecionados,
        builder:(context, value, child){
          return Wrap(
            spacing: 8.0,
            runSpacing: 0.0,
            children: controller.servicosDisponiveis.map((servico) {
              final isSelected = controller.selecionados.contains(servico);
              return FilterChip(
                label: Text(servico.nome),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                selected: isSelected,
                selectedColor: const Color(0xFFEC489A), // Pink do Studio
                checkmarkColor: Colors.white,
                onSelected: (bool selected) => selected ? controller.addServico(servico) : controller.removeServico(servico),
              );
            }).toList(),
          );

        },
      )
    ],
  );
  }
}

class CalculatedSummary extends StatelessWidget {
  const CalculatedSummary({super.key});

  @override
  Widget build(BuildContext context) {

    final precoFormatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.pink.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.pink.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Coluna do Tempo

          Selector<AgendamentoFieldsController, int>(
            selector: (_, controller) => controller.tempoTotal,
            builder: (context, value, child) {
              return Column(
                children: [
                  const Icon(Icons.access_time, color: Color(0xFFEC489A)),
                  const SizedBox(height: 5),
                  const Text(
                    "Duração",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "$value min",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),


          Container(width: 1, height: 40, color: Colors.pink.withOpacity(0.2)),

          Selector<AgendamentoFieldsController, double>(
            selector: (_, controller) => controller.valorTotal,
            builder: (context, value, child) {
              return Column(
                children: [
                  const Icon(Icons.payments_outlined, color: Colors.green),
                  const SizedBox(height: 5),
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    precoFormatter.format(value),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              );
            },
          )   


        ],
      ),
    );
  }
}

class AgendamentoCalendar extends StatelessWidget {
  const AgendamentoCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AgendamentoFieldsController>();
    return Card(
      child: Column(
        children: [
          // Seletor de Data
          ListTile(
            leading: const Icon(Icons.calendar_month, color: Color(0xFFEC489A)),
            title: Text(
              DateFormat('dd/MM/yyyy').format(controller.dataSelecionada),
            ),
            trailing: const Icon(Icons.edit, size: 20),
            onTap: () => _selecionarData(context, controller), // Abre o calendário
          ),
          const Divider(height: 1),

          // Grade de Horários

          if(controller.isDayBlocked) Text("Dia bloqueado")
          
          
          else Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Horários Disponíveis",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.horariosVagos.map((hora) {

                    return Selector<AgendamentoFieldsController, String?>(
                      selector: (_, controller) => controller.horarioSelecionado,
                      builder: (context, value, child) {
                      final isSelected = value == hora;
                        return ChoiceChip(
                          label: Text(hora),
                          selected: isSelected,
                          selectedColor: const Color(0xFFEC489A),
                          onSelected: (bool selected) {
                            controller.setHorarioSelecionado(
                              selected ? hora : null,
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selecionarData(BuildContext context, AgendamentoFieldsController controller) async{

    final date = await showDatePicker(
      context: context,
      initialDate: controller.dataSelecionada,
      firstDate:   DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) controller.setDataSelecionada(date);


    
  }
}
