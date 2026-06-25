import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/roulette_viewmodel.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/services/notification_service.dart'; // ← ДОБАВЬ

class RouletteScreen extends StatefulWidget {
  const RouletteScreen({super.key});

  @override
  State<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends State<RouletteScreen>
    with TickerProviderStateMixin {
  final _amountController = TextEditingController();
  late AnimationController _wheelController;

  @override
  void initState() {
    super.initState();
    _wheelController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _wheelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Financial Roulette',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter amount and select categories to spin',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),

          // Amount Input
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<RouletteViewModel>(
                    builder: (context, viewModel, _) => TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final normalized = value.replaceAll(',', '.');
                        viewModel.setTotalAmount(
                          double.tryParse(normalized) ?? 0,
                        );
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter amount',
                        prefixText: '\$ ',
                        prefixStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(
                              context,
                              // ignore: deprecated_member_use
                            ).primaryColor.withOpacity(0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Categories Selection
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Categories',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<RouletteViewModel>(
                    builder: (context, viewModel, _) => Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppConstants.categories
                          .map(
                            (cat) => FilterChip(
                              label: Text(cat),
                              selected: viewModel.selectedCategories.contains(
                                cat,
                              ),
                              onSelected: (selected) {
                                viewModel.toggleCategory(cat);
                              },
                              backgroundColor: Colors.grey[200],
                              selectedColor: Theme.of(context).primaryColor,
                              labelStyle: TextStyle(
                                color:
                                    viewModel.selectedCategories.contains(cat)
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Spin Button
          Consumer<RouletteViewModel>(
            builder: (context, viewModel, _) {
              final isDisabled =
                  viewModel.isSpinning ||
                  viewModel.totalAmount <= 0 ||
                  viewModel.selectedCategories.isEmpty;

              return SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: isDisabled
                      ? null
                      : () async {
                          _wheelController.forward(from: 0.0);
                          await viewModel.spinRoulette();

                          // Провери mounted И контекст до использования
                          if (mounted && viewModel.allocations.isNotEmpty) {
                            // ignore: use_build_context_synchronously
                            NotificationService().showNotification(
                              id: 101,
                              title: '🎉 Roulette Complete!',
                              body:
                                  'Your allocation is ready. Tap to view results.',
                              payload: 'roulette',
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDisabled
                        ? Colors.grey[300]
                        : Theme.of(context).primaryColor,
                    elevation: 4,
                  ),
                  icon: viewModel.isSpinning
                      ? RotationTransition(
                          turns: _wheelController,
                          child: const Icon(Icons.casino),
                        )
                      : const Icon(Icons.casino),
                  label: Text(
                    viewModel.isSpinning ? 'Spinning...' : 'SPIN ROULETTE',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              );
            },
          ),

          if (_amountController.text.isEmpty ||
              context.watch<RouletteViewModel>().selectedCategories.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Center(
                child: Text(
                  '⚠️ Fill amount and select categories',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 32),

          // Results Section
          Consumer<RouletteViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.allocations.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.casino,
                          size: 80,
                          color: Theme.of(
                            context,
                            // ignore: deprecated_member_use
                          ).primaryColor.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Spin to see results',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📊 Allocation Results',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...viewModel.allocations.entries.toList().asMap().entries.map(
                    (e) {
                      final category = e.value.key;
                      final amount = e.value.value;
                      final percentage = (amount / viewModel.totalAmount * 100);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '\$${amount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: percentage / 100,
                                  minHeight: 10,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        viewModel.reset();
                        _amountController.clear();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Start Over'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
