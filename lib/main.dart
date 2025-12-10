import 'package:flutter/material.dart';
import 'screens/home_container.dart';

/// Aplicativo NutriHealth Analytics - Monitoramento Nutricional com IA
/// Projeto III - Ciência de Dados
/// Desenvolvido por: Leonardo Paiva e Salomão Ferreira
void main() {
  runApp(const NutriHealthApp());
}

class NutriHealthApp extends StatelessWidget {
  const NutriHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriHealth Analytics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      home: const HomeContainer(),
    );
  }
}
