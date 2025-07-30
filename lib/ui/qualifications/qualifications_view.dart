import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unetpedia/models/models.dart';
import 'package:unetpedia/ui/qualifications/cubit/grade_calculator_cubit.dart';
import 'package:unetpedia/widgets/buttons/generic_button.dart';
import 'package:unetpedia/widgets/grade_input_row.dart';
import 'package:unetpedia/widgets/main_appbar.dart';

class QualificationView extends StatefulWidget {
  const QualificationView({super.key});

  static const String routeName = 'qualifications_view';

  @override
  State<QualificationView> createState() => _QualificationViewState();
}

class _QualificationViewState extends State<QualificationView> {
  final _formKey = GlobalKey<FormState>();
  final _targetScoreController = TextEditingController(text: '6.0');

  @override
  void initState() {
    super.initState();
    // Initialize with 3 grades by default after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GradeCalculatorCubit>().initializeGrades(3);
    });
  }

  @override
  void dispose() {
    _targetScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MainAppBar(
          title: "Calcula tu Nota",
          isWhite: true,
        ),
        body: BlocBuilder<GradeCalculatorCubit, GradeCalculatorState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Grade inputs
                          ...state.grades.asMap().entries.map((entry) {
                            final index = entry.key;
                            final grade = entry.value;
                            return GradeInputRow(
                              key: ValueKey('grade_$index'),
                              grade: grade,
                              index: index,
                              canRemove: state.grades.length > 2,
                              onGradeChanged: (index, {score, percentage}) {
                                context.read<GradeCalculatorCubit>().updateGrade(
                                  index,
                                  score: score,
                                  percentage: percentage,
                                );
                              },
                              onRemove: () {
                                context.read<GradeCalculatorCubit>().removeGrade(index);
                              },
                            );
                          }).toList(),
                          
                          // Add grade button
                          const SizedBox(height: 16),
                          Center(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                context.read<GradeCalculatorCubit>().addGrade();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar Parcial'),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Results section
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Resultados',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Porcentaje Total:'),
                                      Text(
                                        '${state.calculation.totalPercentage.toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: state.calculation.totalPercentage == 100.0
                                              ? Colors.green
                                              : state.calculation.totalPercentage > 100.0
                                                  ? Colors.red
                                                  : Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Nota Final (Base 9):'),
                                      Text(
                                        state.calculation.finalScore.toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  if (state.calculation.remainingPercentage > 0) ...[
                                    const SizedBox(height: 16),
                                    const Divider(),
                                    const SizedBox(height: 16),
                                    
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _targetScoreController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: 'Nota objetivo (Base 9)',
                                              hintText: '6.0',
                                              isDense: true,
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        ElevatedButton(
                                          onPressed: () {
                                            final target = double.tryParse(_targetScoreController.text);
                                            if (target != null) {
                                              context.read<GradeCalculatorCubit>().calculateNeededScore(target);
                                            }
                                          },
                                          child: const Text('Calcular'),
                                        ),
                                      ],
                                    ),
                                    
                                    if (state.neededScore != null) ...[
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.blue[200]!),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Para alcanzar tu objetivo necesitas:',
                                              style: TextStyle(fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              '${state.neededScore!.toStringAsFixed(1)} puntos (sobre 100)',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Text(
                                              'En el ${state.calculation.remainingPercentage.toStringAsFixed(1)}% restante',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Conversion table reference
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tabla de Conversión',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Conversión de valores porcentuales a calificaciones de 1.0 a 9.0',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('84-85 = 8.0', style: TextStyle(fontSize: 12)),
                                      const Text('62-63 = 6.0', style: TextStyle(fontSize: 12)),
                                      const Text('39-40 = 4.0', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('95+ = 9.0', style: TextStyle(fontSize: 12)),
                                      const Text('51 = 5.0', style: TextStyle(fontSize: 12)),
                                      const Text('28-29 = 3.0', style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Reset button
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.read<GradeCalculatorCubit>().resetCalculator();
                              context.read<GradeCalculatorCubit>().initializeGrades(3);
                            },
                            child: const Text('Reiniciar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: GenericButton(
                            text: "Guardar Cálculo",
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Cálculo guardado exitosamente'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
  }
}
