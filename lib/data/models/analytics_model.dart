class AnalyticsModel {
  final int totalGoals;
  final double totalAmount;
  final Map<String, int> categoryStats;
  final int completedGoals;

  AnalyticsModel({
    this.totalGoals = 0,
    this.totalAmount = 0,
    this.categoryStats = const {},
    this.completedGoals = 0,
  });

  factory AnalyticsModel.empty() => AnalyticsModel();
}
