import 'dart:async';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/data/product_data.dart';
import 'package:ejemplo_app/models/plato_model.dart';

class DataProvider {
  ProductData pd = new ProductData();
  static final StreamController<List<PlatoModel>> _streamController =
      new StreamController.broadcast();

  static Stream<List<PlatoModel>> get streamController =>
      _streamController.stream;

  static void obtienePlatosProvider() async {
    final lista = await pd.obtienePlatos();
    _streamController.add(lista);
  }

  static dispose() {
    _streamController.close();
  }
}
