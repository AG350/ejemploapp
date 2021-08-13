import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';

class ProductData {
  final database = Dbase().database;
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
      res = await db.update('platos', plato.toJson(),
          where: 'Codigo = ?', whereArgs: [plato.codigo]);
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return res;
  }

  Future<int> agregaPlato(PlatoModel plato) async {
    int res = 0;
    try {
      final db = await database;
      res = await db.insert('platos', plato.toJson());
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return res;
  }

  Future<PlatoModel> leePlatoByCodigo(String codigo) async {
    PlatoModel plato = new PlatoModel(codigo: '', descripcion: '', precio: 0.0);
    try {
      final db = await database;
      final res =
          await db.query('platos', where: 'Codigo = ?', whereArgs: [codigo]);
      if (res.isNotEmpty) plato = PlatoModel.fromJson(res.first);
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return plato;
  }

  Future<List<PlatoModel>> obtienePlatos() async {
    List<PlatoModel> lstPlatos = [];
    try {
      final db = await database;
      final res = await db.query('platos', orderBy: 'Descripcion');
      lstPlatos = (res.isNotEmpty)
          ? res.map((item) => PlatoModel.fromJson(item)).toList()
          : [];
    } catch (errorsql) {
      print(errorsql.toString());
    } finally {}
    return lstPlatos;
  }
}
