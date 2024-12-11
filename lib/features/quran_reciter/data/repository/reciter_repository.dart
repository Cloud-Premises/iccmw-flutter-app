import 'package:iccmw/features/quran_reciter/data/datasource/reciter_datasource.dart';
import 'package:iccmw/features/quran_reciter/data/models/reciter_model.dart';

abstract class ReciterRepository {
  Future<List<ReciterModel>> getReciters();
}

class ReciterRepositoryImpl implements ReciterRepository {
  final ReciterDataSource _dataSource;

  ReciterRepositoryImpl(this._dataSource);

  @override
  Future<List<ReciterModel>> getReciters() async {
    return await _dataSource.getReciterList();
  }
}
