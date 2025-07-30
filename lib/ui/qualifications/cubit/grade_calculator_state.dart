part of 'grade_calculator_cubit.dart';

class GradeCalculatorState extends Equatable {
  final List<Grade> grades;
  final GradeCalculation calculation;
  final double? neededScore;
  final bool isLoading;
  final String? error;

  const GradeCalculatorState({
    this.grades = const [],
    this.calculation = const GradeCalculation(
      grades: [],
      totalPercentage: 0.0,
      finalScore: 0.0,
    ),
    this.neededScore,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        grades,
        calculation,
        neededScore,
        isLoading,
        error,
      ];

  GradeCalculatorState copyWith({
    List<Grade>? grades,
    GradeCalculation? calculation,
    double? neededScore,
    bool? isLoading,
    String? error,
  }) {
    return GradeCalculatorState(
      grades: grades ?? this.grades,
      calculation: calculation ?? this.calculation,
      neededScore: neededScore ?? this.neededScore,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}