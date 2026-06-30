import '../entities/prediction.dart';
import '../repositories/symptom_repository.dart';

class SavePrediction {
  const SavePrediction(this.repository);

  final SymptomRepository repository;

  Future<void> call(Prediction prediction) {
    return repository.savePrediction(prediction);
  }
}
