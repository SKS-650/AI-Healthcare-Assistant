import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../features/symptom_checker/domain/entities/prediction.dart';
import '../features/symptom_checker/presentation/pages/history_page.dart';
import '../features/symptom_checker/presentation/pages/prediction_page.dart';
import '../features/symptom_checker/presentation/pages/symptom_page.dart';
import 'route_names.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => switch (settings.name) {
        RouteNames.splash || RouteNames.symptomChecker => const SymptomPage(),
        RouteNames.history => const HistoryPage(),
        RouteNames.prediction => PredictionPage(
            prediction: settings.arguments is Prediction
                ? settings.arguments! as Prediction
                : Prediction.empty(),
          ),
        _ => const _NotFoundPage(),
      },
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
      body: const Center(child: Text('Page not found')),
    );
  }
}
