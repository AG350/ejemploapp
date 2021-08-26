import 'dart:async';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/models.dart';

class DataProvider {
  static final StreamController<List<PlatoModel>> _streamController = new StreamController.broadcast();
  static final StreamController<List<PlatoModel>> _carroStreamController = new StreamController.broadcast();
  static final StreamController<PlatoModel> _platoEditStreamController = new StreamController.broadcast();
  static StreamController<int> _streamControllerInt = new StreamController.broadcast();

  static final StreamController<UsuarioModel> _userStreamController = new StreamController.broadcast();

  static List<PlatoModel> carritoTemporal = [];
  static PlatoModel? platoEditar;

  /*Carrito*/

  static Stream<int> get cantidadCarroStream => _streamControllerInt.stream;
  static Stream<List<PlatoModel>> get carroStream {
    _carroStreamController.add(carritoTemporal);
    return _carroStreamController.stream;
  }

  static void agregarItemCarrito(PlatoModel plato) {
    carritoTemporal.add(plato);
    _streamControllerInt.add(carritoTemporal.length);
    _carroStreamController.add(carritoTemporal);
  }

  static void quitarItemCarrito(PlatoModel plato) {
    carritoTemporal.remove(plato);
    _streamControllerInt.add(carritoTemporal.length);
    _carroStreamController.add(carritoTemporal);
  }

  /*Plato*/
  static Stream<List<PlatoModel>> get streamController => _streamController.stream;
  static Stream<PlatoModel> get platoEditstreamController => _platoEditStreamController.stream;

  static void cargarPlatoEditarProvider(PlatoModel plato) async {
    _platoEditStreamController.add(plato);
    return;
  }

  static void obtienePlatosProvider() async {
    final db = new Dbase();
    final lista = await db.obtienePlatos();
    _streamController.add(lista);
    return;
  }

  static void obtienePlatoBuscado(PlatoModel platoSelecciondo) {
    final lista = [platoSelecciondo];
    _streamController.add(lista);
    return;
  }

  static void obtienePlatosCarroProvider() {
    _streamController.add(carritoTemporal);
    return;
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
  static Stream<UsuarioModel> get userStreamController => _userStreamController.stream;

  static void obtienerUsuario(String email, String pass) async {
    final db = new Dbase();
    final UsuarioModel usuario = await db.obtenerUsuario(email, pass);

    _userStreamController.add(usuario);
  }

  static dispose() {
    _streamController.close();
    _userStreamController.close();
    _streamControllerInt.close();
    _carroStreamController.close();
    _platoEditStreamController.close();
  }
}
