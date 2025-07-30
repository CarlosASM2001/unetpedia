import 'package:equatable/equatable.dart';

class Grade extends Equatable {
  final double score;
  final double percentage;

  const Grade({
    required this.score,
    required this.percentage,
  });

  double get convertedScore {
    if (score < 0) return 0.0;
    if (score > 100) return 9.0;
    
    //Tabla de conversion
    Map<int, double> conversionTable = {
      // Row 0: 0-9 (7 o menos = 0.0)
      0: 1.0, 1: 1.0, 2: 1.0, 3: 1.0, 4: 1.0, 5: 1.0, 6: 1.0, 7: 1.0, 8: 1.1, 9: 1.2,
      // Row 1: 10-19  
      10: 1.3, 11: 1.4, 12: 1.5, 13: 1.6, 14: 1.7, 15: 1.8, 16: 1.9, 17: 2.0, 18: 2.0, 19: 2.1,
      // Row 2: 20-29
      20: 2.2, 21: 2.3, 22: 2.4, 23: 2.5, 24: 2.6, 25: 2.7, 26: 2.8, 27: 2.9, 28: 3.0, 29: 3.0,
      // Row 3: 30-39
      30: 3.1, 31: 3.2, 32: 3.3, 33: 3.4, 34: 3.5, 35: 3.6, 36: 3.7, 37: 3.8, 38: 3.9, 39: 4.0,
      // Row 4: 40-49
      40: 4.0, 41: 4.1, 42: 4.2, 43: 4.3, 44: 4.4, 45: 4.5, 46: 4.6, 47: 4.7, 48: 4.8, 49: 4.8,
      // Row 5: 50-59 (51 = 5.0)
      50: 4.9, 51: 5.0, 52: 5.1, 53: 5.2, 54: 5.3, 55: 5.3, 56: 5.4, 57: 5.5, 58: 5.6, 59: 5.7,
      // Row 6: 60-69 (62-63 = 6.0, 70 = 6.7)
      60: 5.8, 61: 5.9, 62: 6.0, 63: 6.0, 64: 6.1, 65: 6.2, 66: 6.3, 67: 6.4, 68: 6.5, 69: 6.6,
      // Row 7: 70-79 (70=6.7, 73-74=7.0, 75=7.1, 80=7.6)
      70: 6.7, 71: 6.8, 72: 6.9, 73: 7.0, 74: 7.0, 75: 7.1, 76: 7.2, 77: 7.3, 78: 7.4, 79: 7.5,
      // Row 8: 80-89 (80=7.6, 84-85=8.0)
      80: 7.6, 81: 7.7, 82: 7.8, 83: 7.9, 84: 8.0, 85: 8.0, 86: 8.1, 87: 8.2, 88: 8.3, 89: 8.4,
      // Row 9: 90-100 (95+ = 9.0)
      90: 8.5, 91: 8.6, 92: 8.7, 93: 8.8, 94: 8.9, 95: 9.0, 96: 9.0, 97: 9.0, 98: 9.0, 99: 9.0, 100: 9.0,
    };
    
    // Round the score to nearest integer for table lookup
    int roundedScore = score.round();
    return conversionTable[roundedScore] ?? 0.0;
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