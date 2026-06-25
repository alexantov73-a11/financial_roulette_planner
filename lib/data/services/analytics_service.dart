import '../models/goal_model.dart';
import '../models/analytics_model.dart';

class AnalyticsService {
  AnalyticsModel calculateAnalytics(List<GoalModel> goals) {
    final categoryStats = <String, int>{};
    double totalAmount = 0;
    int completed = 0;

    for (var goal in goals) {
      categoryStats[goal.category] = (categoryStats[goal.category] ?? 0) + 1;
      totalAmount += goal.amount;
      if (goal.completed) completed++;
    }

    return AnalyticsModel(
      totalGoals: goals.length,
      totalAmount: totalAmount,
      categoryStats: categoryStats,
      completedGoals: completed,
    );
  }
}
