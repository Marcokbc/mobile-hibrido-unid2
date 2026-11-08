import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_rotina/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('EcoRotina smoke test - carrega tela principal e navega para segunda tela',
      (WidgetTester tester) async {
    // Inicializa o app
    await tester.pumpWidget(const EcoRotinaApp());
    await tester.pumpAndSettle();

    // Verifica se o título do app está presente
    expect(find.text('EcoRotina'), findsOneWidget);

    // Verifica se o botão de adicionar novo hábito está presente
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verifica se os botões de filtros de categoria aparecem
    expect(find.text('Todos'), findsOneWidget);
    expect(find.text('Água'), findsWidgets);

    // Navega para a segunda tela clicando no ícone de estatísticas
    final botaoInsights = find.byTooltip('Ver Impacto & Dicas (2ª Tela)');
    expect(botaoInsights, findsOneWidget);
    await tester.tap(botaoInsights);
    await tester.pumpAndSettle();

    // Verifica elementos da segunda tela
    expect(find.text('Impacto & Conquistas'), findsOneWidget);
    expect(find.text('Dica Sustentável do Dia'), findsOneWidget);
    expect(find.text('Medalhas & Conquistas Ecológicas'), findsOneWidget);

    // Volta para a tela principal
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('EcoRotina'), findsOneWidget);
  });
}
