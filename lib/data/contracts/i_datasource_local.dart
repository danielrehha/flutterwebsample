import 'package:meta/meta.dart';

abstract class ILocalDataSource {
  Future<void> saveLangIso639CodeAsync({@required String langIso639Code});
  Future<String> loadLangIso639CodeAsync();
}
