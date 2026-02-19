import 'package:cloud_firestore/cloud_firestore.dart';

DateTime? toDate(dynamic timestamp) {
  // Se o valor for nulo, retorna nulo imediatamente.
  if (timestamp == null || timestamp is! Timestamp) {
    return null;
  }
  // Se for um Timestamp válido, converte.
  return timestamp.toDate();  
}
