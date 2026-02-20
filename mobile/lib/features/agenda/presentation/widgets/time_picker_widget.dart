import 'package:flutter/material.dart';

class TimePickerTileWidget extends StatelessWidget {
  const TimePickerTileWidget({super.key, required this.label, required this.time, required this.onTap});

  final String label;
  final String time;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFEC489A))),
      onTap: onTap
    );
  }

}