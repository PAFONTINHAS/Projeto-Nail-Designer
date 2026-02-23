import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile/core/firebase/firebase_options.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';

class AppInitializer {
  AppInitializer ._();

  static Future<void> conectToFirebase() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );

    await FirebaseAppCheck.instance.activate(
      providerAndroid: kDebugMode ? AndroidDebugProvider() : AndroidPlayIntegrityProvider()
    ).catchError((e) => logger.e("Erro ao ativar: $e"));
  }
}