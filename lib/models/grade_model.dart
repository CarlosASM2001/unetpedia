import 'package:equatable/equatable.dart';

class Grade extends Equatable {
  final double score;
  final double percentage;

  const Grade({
    required this.score,
    required this.percentage,
  });

  // Convert grade from 0-100 to base 9 scale
  double get convertedScore {
    if (score < 0) return 0.0;
    if (score > 100) return 9.0;
    return score / 100 * 9.0;
  }

  // Calculate weighted score (converted score * percentage)
  double get weightedScore {
    return convertedScore * (percentage / 100);
  }

  @override
  List<Object?> get props => [score, percentage];

  Grade copyWith({
    double? score,
    double? percentage,
  }) {
    return Grade(
      score: score ?? this.score,
      percentage: percentage ?? this.percentage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'percentage': percentage,
    };
  }

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      score: (json['score'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}

class GradeCalculation extends Equatable {
  final List<Grade> grades;
  final double totalPercentage;
  final double finalScore;

  const GradeCalculation({
    required this.grades,
    required this.totalPercentage,
    required this.finalScore,
  });

  bool get isComplete => totalPercentage >= 100.0;
  
  double get remainingPercentage => 100.0 - totalPercentage;

  // Get suggested percentage distributions based on number of grades
  static List<double> getSuggestedPercentages(int gradeCount) {
    switch (gradeCount) {
      case 2:
        return [50.0, 50.0];
      case 3:
        return [30.0, 35.0, 35.0];
      case 4:
        return [25.0, 35.0, 25.0, 15.0];
      default:
        // For other cases, distribute evenly
        double percentage = 100.0 / gradeCount;
        return List.generate(gradeCount, (index) => percentage);
    }
  }

  // Calculate what score is needed for remaining percentage to reach target
  double calculateNeededScore(double targetFinalScore) {
    if (remainingPercentage <= 0) return 0.0;
    
    double currentWeightedSum = grades.fold(0.0, (sum, grade) => sum + grade.weightedScore);
    double neededWeightedScore = targetFinalScore - currentWeightedSum;
    double neededConvertedScore = neededWeightedScore / (remainingPercentage / 100);
    
    // Convert back to 0-100 scale
    double neededScore = neededConvertedScore * 100 / 9;
    return neededScore.clamp(0.0, 100.0);
  }

  @override
  List<Object?> get props => [grades, totalPercentage, finalScore];

  factory GradeCalculation.calculate(List<Grade> grades) {
    double totalPercentage = grades.fold(0.0, (sum, grade) => sum + grade.percentage);
    double finalScore = grades.fold(0.0, (sum, grade) => sum + grade.weightedScore);
    
    return GradeCalculation(
      grades: grades,
      totalPercentage: totalPercentage,
      finalScore: finalScore,
    );
  }
}