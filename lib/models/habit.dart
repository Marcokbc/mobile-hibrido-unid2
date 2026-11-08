import 'package:flutter/material.dart';

/// Enumeração com as categorias de hábitos sustentáveis disponíveis no app.
/// Cada categoria possui um nome legível, um ícone representativo e uma cor temática.
enum HabitCategory {
  agua,
  energia,
  residuos,
  mobilidade,
  consumo;

  String get label {
    switch (this) {
      case HabitCategory.agua:
        return 'Água';
      case HabitCategory.energia:
        return 'Energia';
      case HabitCategory.residuos:
        return 'Resíduos';
      case HabitCategory.mobilidade:
        return 'Mobilidade';
      case HabitCategory.consumo:
        return 'Consumo';
    }
  }

  IconData get icon {
    switch (this) {
      case HabitCategory.agua:
        return Icons.water_drop;
      case HabitCategory.energia:
        return Icons.bolt;
      case HabitCategory.residuos:
        return Icons.recycling;
      case HabitCategory.mobilidade:
        return Icons.directions_bike;
      case HabitCategory.consumo:
        return Icons.shopping_bag;
    }
  }

  Color get color {
    switch (this) {
      case HabitCategory.agua:
        return Colors.blue;
      case HabitCategory.energia:
        return Colors.amber.shade800;
      case HabitCategory.residuos:
        return Colors.teal;
      case HabitCategory.mobilidade:
        return Colors.deepOrange;
      case HabitCategory.consumo:
        return Colors.purple;
    }
  }
}

/// Modelo que representa um hábito ou meta sustentável na nossa lista.
/// Contém as informações do hábito e os valores estimados de impacto ecológico.
class Habit {
  final String id;
  final String title;
  final HabitCategory category;
  bool isCompleted;
  final double waterSavedLiters; // Economia estimada de água em litros
  final double co2AvoidedKg;     // Redução estimada de CO2 em quilogramas
  final double energySavedKwh;   // Economia estimada de energia em kWh
  final DateTime createdAt;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
    this.waterSavedLiters = 0.0,
    this.co2AvoidedKg = 0.0,
    this.energySavedKwh = 0.0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// ETAPA 1 DA PERSISTÊNCIA (Serialização):
  /// Converte a instância da classe Habit para um `Map<String, dynamic>`.
  /// O SharedPreferences só aceita tipos primitivos (como String), portanto
  /// precisamos transformar nosso objeto num formato chave-valor para depois
  /// transformá-lo em texto JSON.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'isCompleted': isCompleted,
      'waterSavedLiters': waterSavedLiters,
      'co2AvoidedKg': co2AvoidedKg,
      'energySavedKwh': energySavedKwh,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// ETAPA 2 DA PERSISTÊNCIA (Desserialização):
  /// Reconstrói um objeto Habit a partir de um Map gerado pela leitura do JSON.
  /// Quando o aplicativo abre e lê os dados do armazenamento local, ele recebe um Map
  /// e este construtor preenche cada atributo da classe com segurança.
  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: map['title'] as String? ?? 'Hábito sem título',
      category: HabitCategory.values.firstWhere(
        (c) => c.name == (map['category'] as String?),
        orElse: () => HabitCategory.residuos,
      ),
      isCompleted: map['isCompleted'] as bool? ?? false,
      waterSavedLiters: (map['waterSavedLiters'] as num?)?.toDouble() ?? 0.0,
      co2AvoidedKg: (map['co2AvoidedKg'] as num?)?.toDouble() ?? 0.0,
      energySavedKwh: (map['energySavedKwh'] as num?)?.toDouble() ?? 0.0,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
