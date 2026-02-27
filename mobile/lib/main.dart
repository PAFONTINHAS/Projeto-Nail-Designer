import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile/core/services/in_app_alert_service.dart';
import 'package:provider/provider.dart';
import 'package:mobile/core/app/app_initializer.dart';
import 'package:mobile/core/dependency_injection/dependency_injection.dart';
import 'package:mobile/features/auth/presentation/pages/splash_screen.dart';

void main() async{


  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.conectToFirebase();

  await initializeDateFormatting("pt_BR", null);

  final DependencyInjection dependencyInjection = DependencyInjection();

  runApp(MultiProvider(
    providers: [
      ...dependencyInjection.providers
    ],
    child: const MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: InAppAlertService.navigatorKey,
      title: 'Projeto Nail Designer',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}