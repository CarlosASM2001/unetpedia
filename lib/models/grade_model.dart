import 'package:equatable/equatable.dart';

class Grade extends Equatable {
  final double score;
  final double percentage;

  const Grade({
    required this.score,
    required this.percentage,
  });

  // Convert grade from 0-100 to base 9 scale using conversion table
  double get convertedScore {
    if (score < 0) return 0.0;
    if (score > 100) return 9.0;
    
    // Based on the conversion table from the image
    if (score >= 95) return 9.0;
    if (score >= 84) return 8.0;  // 84-85 = 8.0
    if (score >= 73) return 7.0;  // 73-74 = 7.0
    if (score >= 62) return 6.0;  // 62-63 = 6.0
    if (score >= 51) return 5.0;  // 51 = 5.0
    if (score >= 39) return 4.0;  // 39-40 = 4.0
    if (score >= 28) return 3.0;  // 28-29 = 3.0
    if (score >= 17) return 2.0;  // 17-18 = 2.0
    if (score >= 8) return 1.0;   // 8 = 1.0
    return 0.0;  // 7 or less = 0.0
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
    
    // Convert back to 0-100 scale using conversion table logic
    double neededScore = _convertBase9ToScore(neededConvertedScore);
    return neededScore.clamp(0.0, 100.0);
  }

  // Helper method to convert base 9 score back to 0-100 scale
  static double _convertBase9ToScore(double base9Score) {
    if (base9Score >= 9.0) return 95.0;  // Need at least 95 for 9.0
    if (base9Score >= 8.0) return 84.0;  // Need at least 84 for 8.0
    if (base9Score >= 7.0) return 73.0;  // Need at least 73 for 7.0
    if (base9Score >= 6.0) return 62.0;  // Need at least 62 for 6.0
    if (base9Score >= 5.0) return 51.0;  // Need at least 51 for 5.0
    if (base9Score >= 4.0) return 39.0;  // Need at least 39 for 4.0
    if (base9Score >= 3.0) return 28.0;  // Need at least 28 for 3.0
    if (base9Score >= 2.0) return 17.0;  // Need at least 17 for 2.0
    if (base9Score >= 1.0) return 8.0;   // Need at least 8 for 1.0
    return 0.0;  // Less than 1.0 = 0.0
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