import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

/// ============================================================================
/// SERVIÇO DE PERSISTÊNCIA LOCAL (StorageService)
/// ============================================================================
/// 
/// Nesta classe, nós (a dupla) implementamos a persistência dos dados no dispositivo
/// utilizando o pacote 'shared_preferences'. O SharedPreferences funciona como um banco
/// de dados local do tipo chave-valor, onde os dados ficam gravados permanentemente no
/// armazenamento interno do celular do usuário (mesmo após fechar ou reiniciar o app).
class StorageService {
  // Chave única usada para identificar onde a lista de hábitos está salva no aparelho.
  static const String _chaveArmazenamento = 'ecorotina_lista_habitos_v1';

  /// --------------------------------------------------------------------------
  /// ETAPA 1 DA PERSISTÊNCIA: SALVAR OS DADOS NO DISPOSITIVO
  /// --------------------------------------------------------------------------
  /// Esta função é chamada toda vez que o usuário adiciona um novo hábito,
  /// conclui uma meta ou exclui um item da lista.
  /// 
  /// Como funciona o processo de salvar:
  /// 1. Instanciamos o SharedPreferences de forma assíncrona com SharedPreferences.getInstance().
  /// 2. Como o SharedPreferences não consegue salvar listas de objetos Dart diretamente,
  ///    nós percorremos a lista de hábitos e convertemos cada objeto Habit em um Map
  ///    usando a função `habit.toMap()`.
  /// 3. Em seguida, pegamos essa lista de Maps e usamos `jsonEncode()` da biblioteca
  ///    'dart:convert' para transformar tudo em um único texto (String) no formato JSON.
  /// 4. Por fim, chamamos `prefs.setString(_chaveArmazenamento, jsonString)` que grava
  ///    esse texto no armazenamento permanente do Android.
  Future<void> salvarHabitos(List<Habit> habitos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 2. Converte cada objeto Habit da lista em um Map<String, dynamic>
    final List<Map<String, dynamic>> listaDeMaps = habitos.map((h) => h.toMap()).toList();

    // 3. Serializa a lista de Maps em uma String JSON
    final String jsonString = jsonEncode(listaDeMaps);

    // 4. Salva a String JSON na memória permanente associada à chave
    await prefs.setString(_chaveArmazenamento, jsonString);
  }

  /// --------------------------------------------------------------------------
  /// ETAPA 2 DA PERSISTÊNCIA: CARREGAR OS DADOS QUANDO O APP ABRE
  /// --------------------------------------------------------------------------
  /// Esta função é executada no método `initState()` da tela principal logo que o
  /// aplicativo é aberto pelo usuário.
  /// 
  /// Como funciona o processo de carregar:
  /// 1. Obtemos a instância do SharedPreferences com SharedPreferences.getInstance().
  /// 2. Buscamos no disco a String salva sob a nossa chave usando `prefs.getString(_chaveArmazenamento)`.
  /// 3. Se a String não existir (null) ou estiver vazia, significa que é o primeiro acesso
  ///    do usuário ao app. Nesse caso, criamos uma lista padrão com sugestões úteis
  ///    de hábitos sustentáveis para o app já abrir bonito e funcional, e já a salvamos.
  /// 4. Se a String existir, usamos o `jsonDecode()` para decodificar o texto JSON de volta
  ///    em uma lista de dados dinâmicos (`List<dynamic>`).
  /// 5. Depois, fazemos um `map` nessa lista dinâmica chamando o construtor `Habit.fromMap(item)`,
  ///    o que reconstrói cada objeto Habit na memória com seu status de concluído,
  ///    impacto ambiental e detalhes intactos.
  /// 6. Retornamos a lista final pronta para ser exibida na ListView da interface.
  Future<List<Habit>> carregarHabitos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 2. Tenta recuperar o texto JSON salvo
    final String? jsonString = prefs.getString(_chaveArmazenamento);

    // 3. Se ainda não há nada salvo (primeiro uso), carrega hábitos padrão de exemplo
    if (jsonString == null || jsonString.isEmpty) {
      final habitosIniciais = _gerarHabitosIniciais();
      await salvarHabitos(habitosIniciais);
      return habitosIniciais;
    }

    try {
      // 4. Decodifica o texto JSON em lista dinâmica
      final List<dynamic> listaDecodificada = jsonDecode(jsonString) as List<dynamic>;

      // 5. Converte cada Map decodificado de volta em um objeto Habit
      final List<Habit> habitosRecuperados = listaDecodificada
          .map((item) => Habit.fromMap(item as Map<String, dynamic>))
          .toList();

      return habitosRecuperados;
    } catch (e) {
      // Caso ocorra alguma inconsistência de formato, retornamos a lista padrão
      return _gerarHabitosIniciais();
    }
  }

  /// Hábitos sugeridos inicialmente no primeiro uso do app para inspirar a dupla
  /// e o usuário com metas práticas alinhadas às ODS da ONU.
  List<Habit> _gerarHabitosIniciais() {
    return [
      Habit(
        id: '1',
        title: 'Fechar a torneira ao escovar os dentes',
        category: HabitCategory.agua,
        isCompleted: true,
        waterSavedLiters: 12.0,
        co2AvoidedKg: 0.1,
        energySavedKwh: 0.05,
      ),
      Habit(
        id: '2',
        title: 'Apagar as luzes e monitor ao sair do quarto/sala',
        category: HabitCategory.energia,
        isCompleted: false,
        waterSavedLiters: 0.0,
        co2AvoidedKg: 0.35,
        energySavedKwh: 1.2,
      ),
      Habit(
        id: '3',
        title: 'Usar garrafa reutilizável na faculdade',
        category: HabitCategory.residuos,
        isCompleted: true,
        waterSavedLiters: 3.0,
        co2AvoidedKg: 0.4,
        energySavedKwh: 0.2,
      ),
      Habit(
        id: '4',
        title: 'Ir a pé ou de carona solidária para o campus',
        category: HabitCategory.mobilidade,
        isCompleted: false,
        waterSavedLiters: 0.0,
        co2AvoidedKg: 2.1,
        energySavedKwh: 0.0,
      ),
      Habit(
        id: '5',
        title: 'Evitar sacolas plásticas em compras rápidas',
        category: HabitCategory.consumo,
        isCompleted: false,
        waterSavedLiters: 5.0,
        co2AvoidedKg: 0.25,
        energySavedKwh: 0.1,
      ),
    ];
  }
}
