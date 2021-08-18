import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static final Pref _instancia = new Pref._internal();

  factory Pref() {
    return _instancia;
  }

  Pref._internal();

  SharedPreferences? _prefs;

  initPref() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  String get usuario => _prefs?.getString('userName') ?? '';
  set usuario(String usuario) {
    _prefs?.setString('userName', usuario);
    print(this.usuario);  
  }
}
