import 'package:flutter/material.dart';
import '../models/habit.dart';

/// ============================================================================
/// SEGUNDA TELA: ESTATÍSTICAS DE IMPACTO, CONQUISTAS E DICA DO DIA
/// ============================================================================
/// Atende ao requisito de navegação entre telas no Flutter (Navigator.push / pop)
/// e apresenta diferenciais criativos ecológicos:
/// 1. Cálculo aprofundado de impacto ambiental acumulado.
/// 2. Dica do Dia de Sustentabilidade dinâmica e inspiradora.
/// 3. Gamificação com medalhas de conquistas desbloqueadas pelas ações do usuário.
/// 4. Contextualização com as ODS da ONU (ODS 12 e 13).
class StatsScreen extends StatefulWidget {
  final List<Habit> habitos;

  const StatsScreen({super.key, required this.habitos});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  // Lista de dicas práticas de sustentabilidade para o cotidiano universitário e doméstico
  final List<String> _dicas = [
    '💡 Dica de Ouro: Apagar monitores e luzes de salas vazias economiza até 15% na conta de energia da faculdade ou de casa.',
    '🚿 Banhos de 5 minutos economizam cerca de 90 litros de água potável em comparação a um banho de 15 minutos.',
    '🥤 Levar uma garrafa d’água reutilizável evita o descarte de aproximadamente 167 copos plásticos por mês.',
    '🚲 Utilizar bicicleta ou caminhar em trajetos curtos (< 3km) evita a emissão de até 500g de CO₂ por percurso.',
    '🌿 Cascas de frutas e borra de café viram adubo orgânico excelente para pequenos vasos e hortas em apartamentos.',
    '🛍️ Deixar uma ecobag sempre na mochila impede o consumo de sacolas plásticas que levam 400 anos para se decompor.',
  ];

  late int _indiceDicaAtual;

  @override
  void initState() {
    super.initState();
    _indiceDicaAtual = DateTime.now().day % _dicas.length;
  }

  void _proximaDica() {
    setState(() {
      _indiceDicaAtual = (_indiceDicaAtual + 1) % _dicas.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final habitosConcluidos = widget.habitos.where((h) => h.isCompleted).toList();
    final totalConcluidos = habitosConcluidos.length;
    final totalHabitos = widget.habitos.length;
    final percentual = totalHabitos == 0 ? 0.0 : (totalConcluidos / totalHabitos);

    // Soma do impacto gerado pelos hábitos concluídos
    double aguaTotal = 0.0;
    double energiaTotal = 0.0;
    double co2Total = 0.0;

    for (var h in habitosConcluidos) {
      aguaTotal += h.waterSavedLiters;
      energiaTotal += h.energySavedKwh;
      co2Total += h.co2AvoidedKg;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Impacto & Conquistas'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // DIFERENCIAL CRIATIVO 1: CARD DA DICA SUSTENTÁVEL DO DIA
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber.shade800, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Dica Sustentável do Dia',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber.shade900,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, size: 20),
                          tooltip: 'Outra dica',
                          onPressed: _proximaDica,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _dicas[_indiceDicaAtual],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.brown.shade800,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // CARD DE RESUMO GERAL DAS METAS
            Text(
              'Balanço Geral de Hábitos',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$totalConcluidos de $totalHabitos hábitos cumpridos',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          '${(percentual * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: percentual,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.green.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // DETALHAMENTO DO IMPACTO AMBIENTAL ACUMULADO
            Text(
              'Impacto Ambiental Poupança Acumulada',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    context: context,
                    icon: Icons.water_drop,
                    cor: Colors.blue,
                    valor: '${aguaTotal.toStringAsFixed(1)} L',
                    titulo: 'Água Poupada',
                    subtitulo: 'Litros preservados',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    context: context,
                    icon: Icons.bolt,
                    cor: Colors.amber.shade800,
                    valor: '${energiaTotal.toStringAsFixed(1)} kWh',
                    titulo: 'Energia Limpa',
                    subtitulo: 'Redução de consumo',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard(
                    context: context,
                    icon: Icons.cloud_off,
                    cor: Colors.teal.shade700,
                    valor: '${co2Total.toStringAsFixed(2)} kg',
                    titulo: 'CO₂ Evitado',
                    subtitulo: 'Gases estufa a menos',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // DIFERENCIAL CRIATIVO 2: SISTEMA DE MEDALHAS & GAMIFICAÇÃO
            Text(
              'Medalhas & Conquistas Ecológicas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            _buildAchievementTile(
              titulo: 'Iniciativa Verde',
              descricao: 'Concluiu seu primeiro hábito sustentável no app.',
              desbloqueado: totalConcluidos >= 1,
              icon: Icons.military_tech,
              cor: Colors.green,
            ),
            _buildAchievementTile(
              titulo: 'Guardião das Águas',
              descricao: 'Economizou mais de 10 litros de água potável.',
              desbloqueado: aguaTotal >= 10.0,
              icon: Icons.waves,
              cor: Colors.blue,
            ),
            _buildAchievementTile(
              titulo: 'Aliado do Clima',
              descricao: 'Evitou a emissão de mais de 0.5 kg de CO₂.',
              desbloqueado: co2Total >= 0.5,
              icon: Icons.eco,
              cor: Colors.teal,
            ),
            _buildAchievementTile(
              titulo: 'Mestre da Eficiência',
              descricao: 'Concluiu pelo menos 4 hábitos na sua rotina diária.',
              desbloqueado: totalConcluidos >= 4,
              icon: Icons.star,
              cor: Colors.amber.shade700,
            ),
            const SizedBox(height: 24),

            // SEÇÃO INFORMATIVA: ODS DA ONU & PROJETO ACADÊMICO
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.public, color: Colors.green.shade800),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Alinhamento com as ODS da ONU',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Este aplicativo foi desenvolvido para a disciplina de Desenvolvimento Mobile Híbrido, com o objetivo de conscientizar e transformar atitudes em impactos mensuráveis.\n\n'
                    '• ODS 12: Consumo e Produção Responsáveis (redução de desperdício de água, energia e resíduos plásticos).\n'
                    '• ODS 13: Ação Contra a Mudança Global do Clima (diminuição da pegada individual de carbono).',
                    style: TextStyle(fontSize: 13, height: 1.4, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required IconData icon,
    required Color cor,
    required String valor,
    required String titulo,
    required String subtitulo,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: cor.withValues(alpha: 0.15),
              child: Icon(icon, color: cor, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              valor,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              subtitulo,
              style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementTile({
    required String titulo,
    required String descricao,
    required bool desbloqueado,
    required IconData icon,
    required Color cor,
  }) {
    return Card(
      elevation: desbloqueado ? 2 : 0,
      color: desbloqueado ? Colors.white : Colors.grey.shade100,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: desbloqueado ? cor.withValues(alpha: 0.4) : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: desbloqueado ? cor.withValues(alpha: 0.15) : Colors.grey.shade300,
          child: Icon(
            icon,
            color: desbloqueado ? cor : Colors.grey.shade500,
          ),
        ),
        title: Text(
          titulo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: desbloqueado ? Colors.black87 : Colors.grey.shade600,
          ),
        ),
        subtitle: Text(
          descricao,
          style: TextStyle(
            fontSize: 12,
            color: desbloqueado ? Colors.black54 : Colors.grey.shade500,
          ),
        ),
        trailing: Icon(
          desbloqueado ? Icons.check_circle : Icons.lock_outline,
          color: desbloqueado ? Colors.green : Colors.grey.shade400,
        ),
      ),
    );
  }
}
