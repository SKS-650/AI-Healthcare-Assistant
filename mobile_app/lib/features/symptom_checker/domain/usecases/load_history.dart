import '../entities/prediction.dart';
import '../repositories/symptom_repository.dart';

class LoadHistory {
  const LoadHistory(this.repository);

  final SymptomRepository repository;

  Future<List<Prediction>> call() => repository.loadHistory();
}
