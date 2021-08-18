import 'dart:io';

import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/prefs/prefs.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Dbase {
  static Database? _database;
  static final Dbase _db = new Dbase._();
  final pref = new Pref();

  Dbase._();

  factory Dbase() {
    return _db;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await iniDB();
    return _database!;
  }

  Future<Database> iniDB() async {
    //Path donde esta la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'base.db');
    print('=======================Base===================================');
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE Platos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            codigo TEXT,
            nombre TEXT, 
            descripcion TEXT, 
            imagen TEXT, 
            Precio Double
            )''');
        await db.execute('''CREATE TABLE Usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT,
            nombre TEXT, 
            password TEXT
            )''');
      },
    );
  }

  // platos
  Future<bool> guardaPlato(PlatoModel plato) async {
    final _plato = await leePlatoByCodigo(plato.codigo);
    if (_plato.codigo != '') {
      final res = await modificaPlato(plato);
      if (res > 0) return true;
    } else {
      final res = await agregaPlato(plato);
      if (res > 0) return true;
    }
    return false;
  }

  Future<int> modificaPlato(PlatoModel plato) async {
    int res = 0;
    try {
      final db = await database;
      res = await db.update('Platos', plato.toJson(),
          where: 'codigo = ?', whereArgs: [plato.codigo]);
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return res;
  }

  Future<int> agregaPlato(PlatoModel plato) async {
    int res = 0;
    try {
      final db = await database;
      res = await db.insert('Platos', plato.toJson());
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return res;
  }

  Future<PlatoModel> leePlatoByCodigo(String codigo) async {
    PlatoModel plato =
        new PlatoModel(codigo: '', nombre: '', descripcion: '', precio: 0.0);
    try {
      final db = await database;
      final res =
          await db.query('Platos', where: 'codigo = ?', whereArgs: [codigo]);
      if (res.isNotEmpty) plato = PlatoModel.fromJson(res.first);
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return plato;
  }

  Future<List<PlatoModel>> leePlatoByTermino(String termino) async {
    List<PlatoModel> lstPlatos = [];
    try {
      final db = await database;
      final res = await db.rawQuery('''
            SELECT * FROM Platos as p
            WHERE p.codigo LIKE \'%$termino%\'
            OR p.nombre LIKE \'%$termino%\'
            OR p.descripcion LIKE \'%$termino%\'
            OR p.id LIKE \'%$termino%\'
          ''');
      lstPlatos = (res.isNotEmpty)
          ? res.map((item) => PlatoModel.fromJson(item)).toList()
          : [];
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return lstPlatos;
  }

  Future<List<PlatoModel>> obtienePlatos() async {
    List<PlatoModel> lstPlatos = [];
    try {
      final db = await database;
      final res = await db.query('Platos', orderBy: 'descripcion');
      lstPlatos = (res.isNotEmpty)
          ? res.map((item) => PlatoModel.fromJson(item)).toList()
          : [];
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return lstPlatos;
  }

  Future<int> deletePlatoPorId(int id) async {
    final db = await database;
    final res = await db.delete('Platos', where: 'id = ?', whereArgs: [id]);
    return res;
  }
  /* 
  --------------------------------------------------------------------------
  ---------------------------   Usuarios  ----------------------------------
  --------------------------------------------------------------------------
  */

  Future<bool> guardarUsuario(UsuarioModel usuario) async {
    final _usuario = await obtenerUsuario(usuario.email, usuario.password);
    if (_usuario.email != '') {
      final res = await modificarUsuario(usuario);
      if (res > 0) return true;
    } else {
      final res = await agregarUsuario(usuario);
      if (res > 0) return true;
    }
    return false;
  }

  Future<int> modificarUsuario(UsuarioModel usuario) async {
    int res = 0;
    try {
      final db = await database;
      res = await db.update('Usuarios', usuario.toJson(),
          where: 'id = ?', whereArgs: [usuario.id]);
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return res;
  }

  Future<int> agregarUsuario(UsuarioModel usuario) async {
    int res = 0;
    try {
      final db = await database;
      res = await db.insert('Usuarios', usuario.toJson());
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return res;
  }

  Future<UsuarioModel> obtenerUsuario(String email, String pass) async {
    UsuarioModel usuario =
        new UsuarioModel(email: '', nombre: '', password: '');
    try {
      final db = await database;
      final res = await db.query('Usuarios',
          where: 'email = ? and password = ?', whereArgs: [email, pass]);
      if (res.isNotEmpty) usuario = UsuarioModel.fromMap(res.first);
      pref.usuario = usuario.nombre;
      print(usuario.nombre);
      print(pref.usuario);
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}

    return usuario;
  }
}
