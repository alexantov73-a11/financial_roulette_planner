// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../viewmodels/goal_edit_viewmodel.dart';
import '../../viewmodels/goals_viewmodel.dart';
import '../../viewmodels/home_viewmodel.dart';
import '../../viewmodels/analytics_viewmodel.dart';
import '../../../core/constants/app_constants.dart';

class GoalEditScreen extends StatefulWidget {
  final String? goalId;

  const GoalEditScreen({super.key, this.goalId});

  @override
  State<GoalEditScreen> createState() => _GoalEditScreenState();
}

class _GoalEditScreenState extends State<GoalEditScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GoalEditViewModel>().reset();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Edit Goal')),
        body: Consumer<GoalEditViewModel>(
          builder: (context, viewModel, _) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showPhotoOptions(context, viewModel),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    child: viewModel.photoPath.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to add photo',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          )
                        : Image.file(
                            File(viewModel.photoPath),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Goal Name'),
                  onChanged: (v) => viewModel.setName(v),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: viewModel.category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: AppConstants.categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) viewModel.setCategory(v);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '\$ ',
                  ),
                  onChanged: (v) {
                    final normalized = v.replaceAll(',', '.');
                    viewModel.setAmount(double.tryParse(normalized) ?? 0);
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () async {
                            await viewModel.saveGoal();
                            if (mounted) {
                              // Обновляем все экраны, которые показывают цели
                              context.read<GoalsViewModel>().loadGoals();
                              context.read<HomeViewModel>().loadData();
                              context
                                  .read<AnalyticsViewModel>()
                                  .loadAnalytics();
                              // ignore: duplicate_ignore
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pop(true);
                            }
                          },
                    child: viewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save Goal'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPhotoOptions(BuildContext context, GoalEditViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final path = await viewModel.pickFromCamera();
                if (path != null) {
                  viewModel.setPhoto(path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final path = await viewModel.pickFromGallery();
                if (path != null) {
                  viewModel.setPhoto(path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
