import 'dart:async';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/models.dart';

class DataProvider {
  static final StreamController<List<PlatoModel>> _streamController =
      new StreamController.broadcast();
  static final StreamController<UsuarioModel> _userStreamController =
      new StreamController.broadcast();

  static StreamController<int> _streamControllerInt =
      new StreamController.broadcast();

  static List<PlatoModel> carritoTemporal = [];
  static int count = 0;

  /*Carrito*/

  static Stream<int> get carroStream => _streamControllerInt.stream;

  static void agregarItemCarrito(PlatoModel plato) async {
    count++;
    carritoTemporal.add(plato);
    _streamControllerInt.add(count);
  }

  static void quitarItemCarrito(PlatoModel plato) async {
    count--;
    carritoTemporal.remove(plato);
    _streamControllerInt.add(count);
  }

  /*Plato*/
  static Stream<List<PlatoModel>> get streamController =>
      _streamController.stream;

  static void obtienePlatosProvider() async {
    final db = new Dbase();
    final lista = await db.obtienePlatos();
    _streamController.add(lista);
    return;
  }

  static void obtienePlatoBuscado(PlatoModel platoSelecciondo) async {
    final lista = [platoSelecciondo];
    _streamController.add(lista);
    return;
  }

  static void obtienePlatosCarro() {
    _streamController.add(carritoTemporal);
  }

  static void searchPlatosProvider(String termino) async {
    final db = new Dbase();
    final lista = await db.leePlatoByTermino(termino);
    _streamController.add(lista);
  }

  static void eliminarPlatoPorId(int id) async {
    final db = new Dbase();
    await db.deletePlatoPorId(id);
    final lista = await db.obtienePlatos();
    _streamController.add(lista);
  }

  /*Usuarios*/
  static Stream<UsuarioModel> get userStreamController =>
      _userStreamController.stream;

  static void obtienerUsuario(String email, String pass) async {
    final db = new Dbase();
    final UsuarioModel usuario = await db.obtenerUsuario(email, pass);

    _userStreamController.add(usuario);
  }

  static dispose() {
    _streamController.close();
    _userStreamController.close();
    _streamControllerInt.close();
  }
}
