import 'package:flutter/material.dart';

import '../../../../constants/app_strings.dart';
import '../controllers/prediction_controller.dart';
import '../widgets/prediction_card.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final PredictionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PredictionController()..loadHistory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text(AppStrings.history)),
          body: _controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : _controller.history.isEmpty
                  ? const Center(child: Text('No predictions yet.'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _controller.history.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return PredictionCard(
                          prediction: _controller.history[index],
                        );
                      },
                    ),
        );
      },
    );
  }
}
