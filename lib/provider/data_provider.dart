import 'dart:async';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/models.dart';

class DataProvider {
  static final StreamController<List<PlatoModel>> _streamController =
      new StreamController.broadcast();
  static final StreamController<UsuarioModel> _userStreamController =
      new StreamController.broadcast();

  static final StreamController<List<PlatoModel>> _cartStreamController =
      new StreamController.broadcast();

  static final List<PlatoModel> carritoTemporal = [];

  /*Carrito*/

  Stream<List<PlatoModel>> carroStream() =>
      _cartStreamController.stream.asBroadcastStream();

  static void agregarItemCarrito(PlatoModel plato) async {
    print(plato.nombre);
    carritoTemporal.add(plato);
    _cartStreamController.add(carritoTemporal);
  }

  /*Plato*/
  static Stream<List<PlatoModel>> get streamController =>
      _streamController.stream;

  static void obtienePlatosProvider(PlatoModel? platoSelecciondo) async {
    if (platoSelecciondo != null) {
      final lista = [platoSelecciondo];
      _streamController.add(lista);
      return;
    } else {
      final db = new Dbase();
      final lista = await db.obtienePlatos();
      print(lista[0].imagen);
      _streamController.add(lista);
      return;
    }
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
    _cartStreamController.close();
  }
}
