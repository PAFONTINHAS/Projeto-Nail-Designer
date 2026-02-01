import 'package:flutter/material.dart';
import 'package:mobile/core/app/app_initializer.dart';
import 'package:mobile/core/dependency_injection/dependency_injection.dart';
import 'package:mobile/features/auth/presentation/pages/splash_screen.dart';
import 'package:mobile/features/home/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.conectToFirebase();

  // runApp(const MyApp());

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
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SplashScreen(),
    );
  }
}