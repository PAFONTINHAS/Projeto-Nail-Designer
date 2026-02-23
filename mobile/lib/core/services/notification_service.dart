import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile/core/firebase/firebase_instances.dart';
import 'package:mobile/core/services/cache_service.dart';
import 'package:mobile/core/services/device_service.dart';
import 'package:mobile/core/services/in_app_alert_service.dart';
import 'package:mobile/features/agenda/presentation/pages/agenda_config_page.dart';

class NotificationService{

  final _messaging = FirebaseInstances.messaging;
  final _firestore = FirebaseInstances.firestore;


  Future<void> init() async{
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized){
      String? token = await _messaging.getToken();

      final userData = await CacheService.getDeviceInfo();

      if(userData == null || userData['token'] != token){
        await saveFCMToken(token);
      } 
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      logger.i("Recebeu uma mensagem com o app aberto: ${message.notification?.title}");
      logger.i("${message.notification?.body}");

      if(message.notification != null){
        InAppAlertService.showNotificationAlert(
          message.notification!.title ?? "Atenção!", 
          message.notification!.body ?? "Você tem uma nova atualização."
        );
      }
    });
  }

  Future<void> saveFCMToken(String? token) async {
    String? deviceId = await DeviceService.getDeviceId();

    if (token == null || deviceId == null) return;

    final Map<String, dynamic> userData = {
      'token': token,
      'usuario': 'Peterson Fontinhas',
      'ultima_atualizacao': FieldValue.serverTimestamp(),
      'plataforma': Platform.isAndroid ? 'Android' : 'IOS',
    };

    try {
      await _firestore.collection('dispositivos_autorizados').doc(deviceId)
        .set(userData, SetOptions(merge: true));

      await CacheService.storeDeviceInfo(userData);


      logger.i("Token FCM sincronizado com sucesso.");
    } catch (e) {
      logger.e("Erro ao salvar token: $e");
    }
  }

}