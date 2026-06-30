import 'package:flutter/foundation.dart';

import '../../domain/entities/prediction.dart';
import '../../domain/repositories/symptom_repository.dart';
import '../../domain/usecases/load_history.dart';

class PredictionController extends ChangeNotifier {
  PredictionController({SymptomRepository? repository})
      : _repository = repository ?? InMemorySymptomRepository();

  final SymptomRepository _repository;

  List<Prediction> history = const [];
  bool isLoading = false;

  Future<void> loadHistory() async {
    isLoading = true;
    notifyListeners();
    history = await LoadHistory(_repository)();
    isLoading = false;
    notifyListeners();
  }
}
