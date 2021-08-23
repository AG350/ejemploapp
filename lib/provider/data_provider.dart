import 'dart:async';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/models.dart';

class DataProvider {
  static final StreamController<List<PlatoModel>> _streamController =
      new StreamController.broadcast();
  static final StreamController<UsuarioModel> _userStreamController =
      new StreamController.broadcast();

  static final StreamController<int> cartStreamController =
      new StreamController.broadcast();

  static final List<PlatoModel> carritoTemporal = [];

  /*Carrito*/

  static Stream<int> get carroStream => cartStreamController.stream;

  static void agregarItemCarrito(PlatoModel plato) async {
    carritoTemporal.add(plato);
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

  static void obtienecCantidadCarro() {
    int count = carritoTemporal.length;
    print('aca $count');
    cartStreamController.add(count);
  }

  static void obtienePlatosCarro() async {
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
    cartStreamController.close();
  }
}
