import '../../data/datasources/local/hive_symptom.dart';
import '../../data/datasources/remote/predict_api.dart';
import '../../data/datasources/remote/symptom_api.dart';
import '../entities/prediction.dart';
import '../entities/symptom.dart';

abstract class SymptomRepository {
  Future<List<Symptom>> loadSymptoms();

  Future<Prediction> predictDisease({
    required List<Symptom> symptoms,
    required double severity,
  });

  Future<List<Prediction>> loadHistory();

  Future<void> savePrediction(Prediction prediction);
}

class InMemorySymptomRepository implements SymptomRepository {
  InMemorySymptomRepository({
    SymptomApi? symptomApi,
    PredictApi? predictApi,
    HiveSymptomStore? store,
  })  : _symptomApi = symptomApi ?? const SymptomApi(),
        _predictApi = predictApi ?? const PredictApi(),
        _store = store ?? HiveSymptomStore.instance;

  final SymptomApi _symptomApi;
  final PredictApi _predictApi;
  final HiveSymptomStore _store;

  @override
  Future<List<Symptom>> loadSymptoms() async => _symptomApi.fetchSymptoms();

  @override
  Future<Prediction> predictDisease({
    required List<Symptom> symptoms,
    required double severity,
  }) {
    return _predictApi.predict(symptoms: symptoms, severity: severity);
  }

  @override
  Future<List<Prediction>> loadHistory() async => _store.loadHistory();

  @override
  Future<void> savePrediction(Prediction prediction) async {
    _store.savePrediction(prediction);
  }
}
