import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';

DateTime? toDate(dynamic timestamp) {
  // Se o valor for nulo, retorna nulo imediatamente.
  if (timestamp == null || timestamp is! Timestamp) {
    return null;
  }
  // Se for um Timestamp válido, converte.
  return timestamp.toDate();  
}

bool isInt(dynamic value){

  logger.i("Verificando valor: $value");
  
  if(value is int) return true;

  return false;
}