import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eco_rotina/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Gera screenshots de evidencia para a documentacao',
      (WidgetTester tester) async {
    // Configura tamanho padrão de celular (412 x 892)
    tester.view.physicalSize = const Size(412, 892);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // 1. TELA PRINCIPAL (Lista + Diferencial Criativo)
    await tester.pumpWidget(const EcoRotinaApp());
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(EcoRotinaApp),
      matchesGoldenFile('goldens/01_tela_principal.png'),
    );

    // 2. MODAL NOVO HÁBITO (Adicionar item)
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(EcoRotinaApp),
      matchesGoldenFile('goldens/02_modal_adicionar_habito.png'),
    );

    // Fecha o modal
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    // 3. TELA COM FILTRO E CONCLUSÃO DE HÁBITOS
    // Conclui o segundo hábito
    final checkboxes = find.byType(Checkbox);
    if (checkboxes.evaluate().length > 1) {
      await tester.tap(checkboxes.at(1));
      await tester.pumpAndSettle();
    }
    await expectLater(
      find.byType(EcoRotinaApp),
      matchesGoldenFile('goldens/03_habito_concluido_impacto_recalculado.png'),
    );

    // 4. SEGUNDA TELA (Estatísticas, Dica do Dia e Resumo de Impacto)
    final botaoInsights = find.byTooltip('Ver Impacto & Dicas (2ª Tela)');
    await tester.tap(botaoInsights);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(EcoRotinaApp),
      matchesGoldenFile('goldens/04_segunda_tela_estatisticas_dica_dia.png'),
    );

    // 5. SEGUNDA TELA - MEDALHAS E ODS ONU
    await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -350));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(EcoRotinaApp),
      matchesGoldenFile('goldens/05_medalhas_conquistas_ods_onu.png'),
    );
  });
}

