import 'package:flutter/material.dart';

import '../../../../constants/app_strings.dart';
import '../../../../routing/route_names.dart';
import '../controllers/symptom_controller.dart';
import '../widgets/severity_slider.dart';
import '../widgets/symptom_card.dart';

class SymptomPage extends StatefulWidget {
  const SymptomPage({super.key});

  @override
  State<SymptomPage> createState() => _SymptomPageState();
}

class _SymptomPageState extends State<SymptomPage> {
  late final SymptomController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SymptomController()..loadSymptoms();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runPrediction() async {
    final prediction = await _controller.predict();
    if (!mounted) {
      return;
    }

    if (prediction == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one symptom.')),
      );
      return;
    }

    await Navigator.of(context).pushNamed(
      RouteNames.prediction,
      arguments: prediction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.symptomChecker),
            actions: [
              IconButton(
                tooltip: AppStrings.history,
                icon: const Icon(Icons.history),
                onPressed: () => Navigator.of(context).pushNamed(
                  RouteNames.history,
                ),
              ),
            ],
          ),
          body: _controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      AppStrings.splashTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(AppStrings.splashSubtitle),
                    const SizedBox(height: 24),
                    SeveritySlider(
                      value: _controller.severity,
                      onChanged: _controller.updateSeverity,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select symptoms',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    ..._controller.symptoms.map(
                      (symptom) => SymptomCard(
                        symptom: symptom,
                        isSelected: _controller.selectedSymptomIds.contains(
                          symptom.id,
                        ),
                        onTap: () => _controller.toggleSymptom(symptom),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: _runPrediction,
                      icon: const Icon(Icons.analytics_outlined),
                      label: const Text('Analyze symptoms'),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
