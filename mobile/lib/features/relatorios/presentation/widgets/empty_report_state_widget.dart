import 'package:flutter/material.dart';

class EmptyReportStateWidget extends StatelessWidget {
  const EmptyReportStateWidget({super.key, required this.mes});

  final String mes;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 50),
        Icon(Icons.auto_awesome_motion_outlined, 
             size: 80, color: Colors.grey[300]),
        const SizedBox(height: 20),
        Text(
          "Sem registros em $mes",
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.bold, 
            color: Colors.grey[600]
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Não encontramos agendamentos ou relatórios fechados para este período.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500]),
          ),
        ),
      ],
    );
  }
}