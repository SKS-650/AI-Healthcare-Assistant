import '../entities/prediction.dart';
import '../entities/symptom.dart';
import '../repositories/symptom_repository.dart';

class PredictDisease {
  const PredictDisease(this.repository);

  final SymptomRepository repository;

  Future<Prediction> call({
    required List<Symptom> symptoms,
    required double severity,
  }) {
    return repository.predictDisease(symptoms: symptoms, severity: severity);
  }
}
