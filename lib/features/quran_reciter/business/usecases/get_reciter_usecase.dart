import 'package:iccmw/features/quran_reciter/data/models/reciter_model.dart';
import 'package:iccmw/features/quran_reciter/data/repository/reciter_repository.dart';

class GetReciterUseCase {
  final ReciterRepository _repository;

  GetReciterUseCase(this._repository);

  Future<List<ReciterModel>> execute() async {
    return await _repository.getReciters();
  }
}
