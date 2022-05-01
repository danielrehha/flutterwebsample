import 'package:allbert_cms/data/contracts/i_datasource_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource implements ILocalDataSource {
  @override
  Future<String> loadLangIso639CodeAsync() async {
    final prefs = await SharedPreferences.getInstance();
    final langIso639Code = await prefs.getString("langIso639Code");
    return langIso639Code;
  }

  @override
  Future<void> saveLangIso639CodeAsync({String langIso639Code}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("langIso639Code", langIso639Code);
  }
}
