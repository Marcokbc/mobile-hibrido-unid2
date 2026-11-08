import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

/// Ponto de entrada principal do aplicativo EcoRotina.
/// Desenvolvido para a atividade OAT da disciplina Desenvolvimento Mobile Híbrido.
void main() {
  // Garante que as ligações do Flutter estejam prontas antes de iniciar o app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EcoRotinaApp());
}

class EcoRotinaApp extends StatelessWidget {
  const EcoRotinaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoRotina - Sustentabilidade',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32), // Verde sustentabilidade florestal
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF00796B),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7FBF7),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
