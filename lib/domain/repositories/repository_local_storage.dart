import 'package:allbert_cms/data/contracts/i_datasource_local.dart';
import 'package:meta/meta.dart';

abstract class ILocalStorageRepository {
}

class LocalStorageRepository implements ILocalStorageRepository {
  final ILocalDataSource localDataSource;

  LocalStorageRepository({@required this.localDataSource});

}
