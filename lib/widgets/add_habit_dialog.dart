import 'package:flutter/material.dart';
import '../models/habit.dart';

/// Modal para adicionar um novo hábito ou meta de sustentabilidade na lista.
class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  HabitCategory _selectedCategory = HabitCategory.agua;
  double _waterEstimate = 10.0;
  double _energyEstimate = 0.5;
  double _co2Estimate = 0.3;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _updateDefaultEstimates(HabitCategory category) {
    setState(() {
      _selectedCategory = category;
      switch (category) {
        case HabitCategory.agua:
          _waterEstimate = 15.0;
          _energyEstimate = 0.2;
          _co2Estimate = 0.15;
          break;
        case HabitCategory.energia:
          _waterEstimate = 0.0;
          _energyEstimate = 1.5;
          _co2Estimate = 0.45;
          break;
        case HabitCategory.residuos:
          _waterEstimate = 4.0;
          _energyEstimate = 0.3;
          _co2Estimate = 0.6;
          break;
        case HabitCategory.mobilidade:
          _waterEstimate = 0.0;
          _energyEstimate = 0.0;
          _co2Estimate = 2.2;
          break;
        case HabitCategory.consumo:
          _waterEstimate = 6.0;
          _energyEstimate = 0.5;
          _co2Estimate = 0.5;
          break;
      }
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final novoHabito = Habit(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        category: _selectedCategory,
        isCompleted: false,
        waterSavedLiters: _waterEstimate,
        energySavedKwh: _energyEstimate,
        co2AvoidedKg: _co2Estimate,
      );

      Navigator.of(context).pop(novoHabito);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Icon(Icons.add_task, color: Colors.green.shade800),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Novo Hábito Verde',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Título do hábito ou meta',
                    hintText: 'Ex.: Tomar banho de até 5 minutos',
                    prefixIcon: const Icon(Icons.eco),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, informe a descrição do hábito.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Categoria:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: HabitCategory.values.map((category) {
                    final isSelected = _selectedCategory == category;
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            category.icon,
                            size: 16,
                            color: isSelected ? Colors.white : category.color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category.label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: category.color,
                      onSelected: (selected) {
                        if (selected) {
                          _updateDefaultEstimates(category);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Impacto ecológico estimado (ao concluir):',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      const SizedBox(height: 6),
                      Text('💧 Água poupada: ${_waterEstimate.toStringAsFixed(1)} Litros'),
                      Text('⚡ Energia poupada: ${_energyEstimate.toStringAsFixed(1)} kWh'),
                      Text('🌱 CO₂ evitado: ${_co2Estimate.toStringAsFixed(2)} kg'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                OverflowBar(
                  alignment: MainAxisAlignment.end,
                  spacing: 8,
                  overflowSpacing: 8,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _submit,
                      icon: const Icon(Icons.check),
                      label: const Text('Salvar Hábito'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

