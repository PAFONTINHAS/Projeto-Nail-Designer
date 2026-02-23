import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {  

  CacheService._();

  static Future<void> storeDeviceInfo(Map<String, dynamic> map) async{

    try{
      final prefs = await SharedPreferences.getInstance();
      final latestUpdate = Timestamp.now().millisecondsSinceEpoch;

      map['ultima_atualizacao'] = latestUpdate;

      final String encodedData = jsonEncode(map);

      await prefs.setString('cache_device_info', encodedData);

    }catch(e){
      logger.e("Erro ao armazenar dados: $e");
    }
  }

  static Future<Map<String, dynamic>?> getDeviceInfo() async{

    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getString('cache_device_info');

    if(data == null) return null;

    try{
      Map<String,dynamic> decodedData = jsonDecode(data);

      final Timestamp latestUpdate = Timestamp.fromMillisecondsSinceEpoch(decodedData['ultima_atualizacao']);

      decodedData['ultima_atualizacao'] = latestUpdate;
      
      return decodedData;

    }catch(e){
      logger.e("Erro ao pegar dados: $e");
      return null;
    }

  }
}