import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/core/firebase/firebase_options.dart';

class AppInitializer {
  AppInitializer ._();

  static Future<void> conectToFirebase() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }
}