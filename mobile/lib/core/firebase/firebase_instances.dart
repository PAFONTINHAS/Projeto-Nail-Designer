import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// classe que consolida todas as instâncias do firebase
class FirebaseInstances {
  FirebaseInstances._();
  
  static final FirebaseAuth auth           = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FirebaseFunctions functions = FirebaseFunctions.instanceFor(region: 'southamerica-east1');

}