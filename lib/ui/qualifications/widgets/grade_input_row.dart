import 'package:flutter/material.dart';
import 'package:unetpedia/models/grade_model.dart';
import 'package:unetpedia/widgets/inputs/form_input.dart';

class GradeInputRow extends StatefulWidget {
  final Grade grade;
  final int index;
  final bool canRemove;
  final Function(int, {double? score, double? percentage}) onGradeChanged;
  final VoidCallback? onRemove;

  const GradeInputRow({
    super.key,
    required this.grade,
    required this.index,
    required this.canRemove,
    required this.onGradeChanged,
    this.onRemove,
  });

  @override
  State<GradeInputRow> createState() => _GradeInputRowState();
}

class _GradeInputRowState extends State<GradeInputRow> {
  late TextEditingController _percentageController;
  late TextEditingController _scoreController;

  @override
  void initState() {
    super.initState();
    _percentageController = TextEditingController(
      text: widget.grade.percentage.toString(),
    );
    _scoreController = TextEditingController(
      text: widget.grade.score > 0 ? widget.grade.score.toString() : '',
    );
  }

  @override
  void didUpdateWidget(GradeInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.grade.percentage != widget.grade.percentage) {
      _percentageController.text = widget.grade.percentage.toString();
    }
    if (oldWidget.grade.score != widget.grade.score) {
      _scoreController.text = widget.grade.score > 0
          ? widget.grade.score.toString()
          : '';
    }
  }

  @override
  void dispose() {
    _percentageController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Parcial ${widget.index + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (widget.canRemove)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FormInput(
                    labelText: "Porcentaje",
                    hintText: "30%",
                    controller: _percentageController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requerido';
                      }
                      final percentage = double.tryParse(value);
                      if (percentage == null ||
                          percentage < 0 ||
                          percentage > 100) {
                        return 'Entre 0-100';
                      }
                      return null;
                    },
                    onChange: (value) {
                      final percentage = double.tryParse(value);
                      if (percentage != null) {
                        widget.onGradeChanged(
                          widget.index,
                          percentage: percentage,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: FormInput(
                    labelText: "Nota",
                    hintText: "0-100",
                    controller: _scoreController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      final score = double.tryParse(value);
                      if (score == null || score < 0 || score > 100) {
                        return 'Entre 0-100';
                      }
                      return null;
                    },
                    onChange: (value) {
                      final score = double.tryParse(value) ?? 0.0;
                      widget.onGradeChanged(widget.index, score: score);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Base 9: ${widget.grade.convertedScore.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  'Ponderado: ${widget.grade.weightedScore.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
