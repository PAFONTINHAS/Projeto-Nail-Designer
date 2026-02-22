import 'dart:convert';

import 'package:mobile/features/relatorios/data/datasource/relatorios_local_datasource.dart';
import 'package:mobile/features/relatorios/domain/entities/relatorio_mensal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelatoriosLocalDatasourceImpl implements RelatoriosLocalDatasource{
  
  Future<SharedPreferences> _getPrefs() async{
    return await SharedPreferences.getInstance();
  }
  
  @override
  Future<void> clearLocalData(String location) async{

    final prefs = await _getPrefs();

    await prefs.remove(location);
  }

  

  @override
  Future<void> storeRelatorios(Map<String, RelatorioMensal> relatorios) async{
    final SharedPreferences prefs = await _getPrefs();

    final String encodedData = jsonEncode(
      relatorios.map((key, value) => MapEntry(key, value.toMap()))
    );

    await prefs.setString('cache_relatorios_mensais', encodedData);
  }

  @override
  Future<Map<String, RelatorioMensal>?> getRelatorios() async{

    final SharedPreferences prefs = await _getPrefs();

    final String? data = prefs.getString('cache_relatorios_mensais');

    if(data == null ) return null;

    final Map<String, dynamic> decodedData = jsonDecode(data);

    return decodedData.map((key, value) => MapEntry(key, RelatorioMensal.fromMap(value)));
  }
}