import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:unetpedia/models/models.dart';

part 'qualification_state.dart';

class QualificationCubit extends Cubit<QualificationState> {
  QualificationCubit() : super(const QualificationState());

  void initializeGrades(int gradeCount) {
    final suggestedPercentages = GradeCalculation.getSuggestedPercentages(
      gradeCount,
    );
    final grades = List.generate(
      gradeCount,
      (index) => Grade(score: 0.0, percentage: suggestedPercentages[index]),
    );

    emit(
      state.copyWith(
        grades: grades,
        calculation: GradeCalculation.calculate(grades),
      ),
    );
  }

  void updateGrade(int index, {double? score, double? percentage}) {
    final grades = List<Grade>.from(state.grades);
    if (index < grades.length) {
      grades[index] = grades[index].copyWith(
        score: score,
        percentage: percentage,
      );

      final calculation = GradeCalculation.calculate(grades);
      emit(state.copyWith(grades: grades, calculation: calculation));
    }
  }

  void addGrade() {
    final currentGrades = List<Grade>.from(state.grades);
    final newGradeCount = currentGrades.length + 1;

    final suggestedPercentages = GradeCalculation.getSuggestedPercentages(
      newGradeCount,
    );
    final grades = List.generate(
      newGradeCount,
      (index) => Grade(
        score: index < currentGrades.length ? currentGrades[index].score : 0.0,
        percentage: suggestedPercentages[index],
      ),
    );

    final calculation = GradeCalculation.calculate(grades);
    emit(state.copyWith(grades: grades, calculation: calculation));
  }

  void removeGrade(int index) {
    if (state.grades.length <= 2) return;

    final grades = List<Grade>.from(state.grades);
    grades.removeAt(index);

    // Redistribute percentages
    final suggestedPercentages = GradeCalculation.getSuggestedPercentages(
      grades.length,
    );
    final updatedGrades = List.generate(
      grades.length,
      (i) => grades[i].copyWith(percentage: suggestedPercentages[i]),
    );

    final calculation = GradeCalculation.calculate(updatedGrades);
    emit(state.copyWith(grades: updatedGrades, calculation: calculation));
  }

  void calculateNeededScore(double targetScore) {
    final neededScore = state.calculation.calculateNeededScore(targetScore);
    emit(state.copyWith(neededScore: neededScore));
  }

  void resetCalculator() {
    emit(const QualificationState());
  }
}
