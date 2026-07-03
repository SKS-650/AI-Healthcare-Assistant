import 'package:flutter/material.dart';

import '../constants/app_strings.dart';
import '../features/symptom_checker/domain/entities/prediction.dart';
import '../features/symptom_checker/presentation/pages/history_page.dart';
import '../features/symptom_checker/presentation/pages/prediction_page.dart';
import '../features/symptom_checker/presentation/pages/symptom_page.dart';
import '../features/disease_prediction/presentation/pages/disease_prediction_page.dart';
import '../features/medical_chatbot/presentation/pages/chatbot_page.dart';
import '../features/emergency/presentation/pages/emergency_page.dart';
import '../features/health_records/presentation/pages/health_records_page.dart';
import '../features/nearby_healthcare/presentation/pages/hospitals_page.dart';
import '../features/health_education/presentation/pages/education_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/notifications/presentation/pages/notifications_page.dart';
import 'route_names.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => switch (settings.name) {
        RouteNames.splash ||
        RouteNames.symptomChecker =>
          const SymptomPage(),
        RouteNames.history => const HistoryPage(),
        RouteNames.prediction => PredictionPage(
            prediction: settings.arguments is Prediction
                ? settings.arguments! as Prediction
                : Prediction.empty(),
          ),
        RouteNames.diseasePrediction =>
          const DiseasePredictionPage(),
        RouteNames.chatbot => const ChatbotPage(),
        RouteNames.emergency => const EmergencyPage(),
        RouteNames.records => const HealthRecordsPage(),
        RouteNames.hospitals => const HospitalsPage(),
        RouteNames.education => const EducationPage(),
        RouteNames.profile => const ProfilePage(),
        RouteNames.notifications => const NotificationsPage(),
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
