import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/storage_service.dart';
import '../widgets/add_habit_dialog.dart';
import 'stats_screen.dart';

/// ============================================================================
/// TELA PRINCIPAL (HomeScreen) - ECO-ROTINA
/// ============================================================================
/// Nesta tela, gerenciamos o estado principal do app:
/// - Exibição da lista de hábitos sustentáveis.
/// - Adição de novos hábitos via Modal Dialog.
/// - Conclusão (checkbox) e exclusão (remover) de hábitos.
/// - Cálculo de impacto dinâmico em tempo real (Diferencial Criativo).
/// - Navegação para a segunda tela (StatsScreen).
/// - Integração com o serviço de persistência local (StorageService).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instância do serviço responsável por ler e gravar os dados no armazenamento do celular
  final StorageService _storageService = StorageService();

  // Lista de hábitos gerenciada na memória RAM do app
  List<Habit> _habitos = [];

  // Variável de controle para indicar se os dados estão sendo lidos do disco
  bool _carregando = true;

  // Filtro de categoria selecionada pelo usuário na tela
  HabitCategory? _categoriaFiltro;

  /// --------------------------------------------------------------------------
  /// CICLO DE VIDA DO FLUTTER: initState()
  /// --------------------------------------------------------------------------
  /// Este método é o primeiro a ser executado quando a tela é inserida na árvore de widgets.
  /// É aqui que iniciamos o carregamento assíncrono dos hábitos que foram previamente
  /// salvos pelo usuário no SharedPreferences.
  @override
  void initState() {
    super.initState();
    _carregarDadosDoDispositivo();
  }

  /// --------------------------------------------------------------------------
  /// ETAPA DE CARREGAMENTO (Persistência):
  /// --------------------------------------------------------------------------
  /// Chamamos o método assíncrono do nosso StorageService. Quando a leitura do
  /// arquivo JSON local terminar, usamos o `setState()` para atualizar a variável
  /// `_habitos` e avisar ao Flutter que a tela deve ser redesenhada com os dados reais.
  Future<void> _carregarDadosDoDispositivo() async {
    final habitosCarregados = await _storageService.carregarHabitos();
    setState(() {
      _habitos = habitosCarregados;
      _carregando = false;
    });
  }

  /// --------------------------------------------------------------------------
  /// ETAPA DE GRAVAÇÃO (Persistência):
  /// --------------------------------------------------------------------------
  /// Sempre que a lista sofre qualquer alteração (adicionar, concluir ou remover),
  /// chamamos esta função para salvar imediatamente a lista inteira atualizada no
  /// SharedPreferences. Dessa forma, mesmo que o usuário feche o app pelo gerenciador
  /// de tarefas do Android, nada é perdido.
  Future<void> _salvarDadosNoDispositivo() async {
    await _storageService.salvarHabitos(_habitos);
  }

  /// Adiciona um novo hábito criado pelo usuário e persiste no disco
  void _adicionarHabito(Habit novoHabito) {
    setState(() {
      _habitos.insert(0, novoHabito);
    });
    _salvarDadosNoDispositivo();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Hábito "${novoHabito.title}" adicionado com sucesso! 🌱'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Alterna o status de concluído do hábito, recalcula o impacto e salva
  void _alternarConclusao(Habit habito) {
    setState(() {
      habito.isCompleted = !habito.isCompleted;
    });
    _salvarDadosNoDispositivo();

    if (habito.isCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Parabéns! Meta sustentável cumprida! 💧⚡🌱'),
          backgroundColor: Colors.teal.shade700,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Remove um hábito da lista após confirmação e atualiza o armazenamento
  void _removerHabito(Habit habito) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir Hábito'),
        content: Text('Tem certeza que deseja remover "${habito.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                _habitos.removeWhere((h) => h.id == habito.id);
              });
              _salvarDadosNoDispositivo();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Hábito removido.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// NAVEGAÇÃO ENTRE TELAS:
  /// --------------------------------------------------------------------------
  /// Abre a segunda tela (StatsScreen) passando a lista atual de hábitos como parâmetro.
  /// Quando o usuário clica no botão "voltar", a tela principal retoma a exibição.
  void _abrirSegundaTela() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StatsScreen(habitos: _habitos),
      ),
    );
  }

  /// Abre o modal dialog para cadastrar um novo hábito sustentável
  Future<void> _abrirModalNovoHabito() async {
    final novoHabito = await showDialog<Habit>(
      context: context,
      builder: (ctx) => const AddHabitDialog(),
    );

    if (novoHabito != null) {
      _adicionarHabito(novoHabito);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtragem dos hábitos conforme a categoria selecionada
    final habitosExibidos = _categoriaFiltro == null
        ? _habitos
        : _habitos.where((h) => h.category == _categoriaFiltro).toList();

    // Cálculos para o Diferencial Criativo (Impacto em Tempo Real)
    final concluidos = _habitos.where((h) => h.isCompleted).toList();
    final totalConcluidos = concluidos.length;
    final totalHabitos = _habitos.length;
    final percentual = totalHabitos == 0 ? 0.0 : (totalConcluidos / totalHabitos);

    double aguaEconomizada = 0.0;
    double energiaEconomizada = 0.0;
    double co2Evitado = 0.0;

    for (var h in concluidos) {
      aguaEconomizada += h.waterSavedLiters;
      energiaEconomizada += h.energySavedKwh;
      co2Evitado += h.co2AvoidedKg;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.eco, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'EcoRotina',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
        actions: [
          // Botão que navega para a Segunda Tela
          IconButton(
            icon: const Icon(Icons.insights),
            tooltip: 'Ver Impacto & Dicas (2ª Tela)',
            onPressed: _abrirSegundaTela,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirModalNovoHabito,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo Hábito'),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ==============================================================
                // DIFERENCIAL CRIATIVO: CARD DE IMPACTO E PROGRESSO DIÁRIO
                // ==============================================================
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Metas Diárias Concluídas',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '$totalConcluidos/$totalHabitos (${(percentual * 100).toInt()}%)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: percentual,
                          minHeight: 8,
                          backgroundColor: Colors.green.shade900,
                          color: Colors.lightGreenAccent,
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Indicadores de economia de impacto em tempo real
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildImpactMiniStat(
                                icon: Icons.water_drop,
                                cor: Colors.blue,
                                valor: '${aguaEconomizada.toStringAsFixed(0)}L',
                                legenda: 'Água salva',
                              ),
                            ),
                            Container(width: 1, height: 28, color: Colors.grey.shade300),
                            Expanded(
                              child: _buildImpactMiniStat(
                                icon: Icons.bolt,
                                cor: Colors.amber.shade800,
                                valor: '${energiaEconomizada.toStringAsFixed(1)} kWh',
                                legenda: 'Energia',
                              ),
                            ),
                            Container(width: 1, height: 28, color: Colors.grey.shade300),
                            Expanded(
                              child: _buildImpactMiniStat(
                                icon: Icons.cloud_off,
                                cor: Colors.teal.shade700,
                                valor: '${co2Evitado.toStringAsFixed(1)} kg',
                                legenda: 'CO₂ evitado',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // FILTROS DE CATEGORIA (Chips horizontais)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Todos'),
                        selected: _categoriaFiltro == null,
                        onSelected: (selected) {
                          setState(() {
                            _categoriaFiltro = null;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ...HabitCategory.values.map((cat) {
                        final isSelected = _categoriaFiltro == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            avatar: Icon(cat.icon, size: 16, color: isSelected ? Colors.white : cat.color),
                            label: Text(cat.label),
                            selected: isSelected,
                            selectedColor: cat.color,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                _categoriaFiltro = selected ? cat : null;
                              });
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // ==============================================================
                // LISTA DE HÁBITOS (Adicionar, Concluir e Remover itens)
                // ==============================================================
                Expanded(
                  child: habitosExibidos.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.nature_people, size: 64, color: Colors.grey.shade400),
                              const SizedBox(height: 12),
                              Text(
                                _categoriaFiltro == null
                                    ? 'Nenhum hábito cadastrado ainda.'
                                    : 'Nenhum hábito na categoria selecionada.',
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Clique em "+ Novo Hábito" para começar!',
                                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(12, 0, 12, 80),
                          itemCount: habitosExibidos.length,
                          itemBuilder: (context, index) {
                            final habito = habitosExibidos[index];
                            return _buildHabitCard(habito);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildImpactMiniStat({
    required IconData icon,
    required Color cor,
    required String valor,
    required String legenda,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: cor, size: 16),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                valor,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey.shade900,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          legenda,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildHabitCard(Habit habito) {
    return Card(
      elevation: habito.isCompleted ? 1 : 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: habito.isCompleted ? Colors.green.shade200 : Colors.grey.shade200,
        ),
      ),
      color: habito.isCompleted ? Colors.green.shade50.withValues(alpha: 0.5) : Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: habito.category.color.withValues(alpha: 0.15),
          child: Icon(
            habito.category.icon,
            color: habito.category.color,
          ),
        ),
        title: Text(
          habito.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: habito.isCompleted ? TextDecoration.lineThrough : null,
            color: habito.isCompleted ? Colors.grey.shade600 : Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: 6,
            runSpacing: 2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: habito.category.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  habito.category.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: habito.category.color,
                  ),
                ),
              ),
              if (habito.waterSavedLiters > 0)
                Text('💧${habito.waterSavedLiters.toInt()}L', style: const TextStyle(fontSize: 11)),
              if (habito.energySavedKwh > 0)
                Text('⚡${habito.energySavedKwh}kWh', style: const TextStyle(fontSize: 11)),
              if (habito.co2AvoidedKg > 0)
                Text('🌱${habito.co2AvoidedKg}kg', style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
        // Ação de CONCLUIR (Checkbox)
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: habito.isCompleted,
              activeColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              onChanged: (_) => _alternarConclusao(habito),
            ),
            // Ação de REMOVER (Botão de lixeira)
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 22),
              tooltip: 'Remover hábito',
              onPressed: () => _removerHabito(habito),
            ),
          ],
        ),
      ),
    );
  }
}
