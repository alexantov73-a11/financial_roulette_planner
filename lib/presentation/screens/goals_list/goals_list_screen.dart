import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/goals_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/analytics_viewmodel.dart';
import '../../../core/constants/app_constants.dart';

class GoalsListScreen extends StatefulWidget {
  const GoalsListScreen({super.key});

  @override
  State<GoalsListScreen> createState() => _GoalsListScreenState();
}

class _GoalsListScreenState extends State<GoalsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GoalsViewModel>().loadGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/goal-edit');
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', ...AppConstants.categories]
                    .map(
                      (cat) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Consumer<GoalsViewModel>(
                          builder: (context, viewModel, _) => FilterChip(
                            label: Text(cat),
                            selected: viewModel.filterCategory == cat,
                            onSelected: (selected) {
                              viewModel.setFilterCategory(cat);
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Expanded(
            child: Consumer<GoalsViewModel>(
              builder: (context, viewModel, _) =>
                  viewModel.filteredGoals.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flag_outlined,
                            size: 80,
                            color: Theme.of(
                              context,
                              // ignore: deprecated_member_use
                            ).primaryColor.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No goals yet',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/goal-edit');
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Create Goal'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: viewModel.filteredGoals.length,
                      itemBuilder: (context, index) {
                        final goal = viewModel.filteredGoals[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: Checkbox(
                              value: goal.completed,
                              onChanged: (value) {
                                viewModel.toggleGoalComplete(goal.id);
                                context.read<HomeViewModel>().loadData();
                                context
                                    .read<AnalyticsViewModel>()
                                    .loadAnalytics();
                              },
                            ),
                            title: Text(
                              goal.name,
                              style: TextStyle(
                                decoration: goal.completed
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${goal.amount}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    Chip(
                                      label: Text(goal.category),
                                      backgroundColor: Theme.of(
                                        context,
                                        // ignore: deprecated_member_use
                                      ).primaryColor.withOpacity(0.1),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: const Row(
                                    children: [
                                      Icon(Icons.delete, size: 20),
                                      SizedBox(width: 8),
                                      Text('Delete'),
                                    ],
                                  ),
                                  onTap: () {
                                    viewModel.deleteGoal(goal.id);
                                    context.read<HomeViewModel>().loadData();
                                    context
                                        .read<AnalyticsViewModel>()
                                        .loadAnalytics();
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.of(
                                context,
                              ).pushNamed('/goal-detail', arguments: goal.id);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
