import 'package:flutter/foundation.dart';

import '../../domain/entities/prediction.dart';
import '../../domain/entities/symptom.dart';
import '../../domain/repositories/symptom_repository.dart';
import '../../domain/usecases/predict_disease.dart';
import '../../domain/usecases/save_prediction.dart';

class SymptomController extends ChangeNotifier {
  SymptomController({SymptomRepository? repository})
      : _repository = repository ?? InMemorySymptomRepository();

  final SymptomRepository _repository;

  List<Symptom> symptoms = const [];
  final Set<String> selectedSymptomIds = <String>{};
  double severity = 4;
  bool isLoading = false;

  List<Symptom> get selectedSymptoms {
    return symptoms
        .where((symptom) => selectedSymptomIds.contains(symptom.id))
        .toList();
  }

  Future<void> loadSymptoms() async {
    isLoading = true;
    notifyListeners();
    symptoms = await _repository.loadSymptoms();
    isLoading = false;
    notifyListeners();
  }

  void toggleSymptom(Symptom symptom) {
    if (!selectedSymptomIds.add(symptom.id)) {
      selectedSymptomIds.remove(symptom.id);
    }
    notifyListeners();
  }

  void updateSeverity(double value) {
    severity = value;
    notifyListeners();
  }

  Future<Prediction?> predict() async {
    if (selectedSymptoms.isEmpty) {
      return null;
    }

    final prediction = await PredictDisease(_repository)(
      symptoms: selectedSymptoms,
      severity: severity,
    );
    await SavePrediction(_repository)(prediction);
    return prediction;
  }
}
