import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';

class MantenimientoPage extends StatefulWidget {
  @override
  _MantenimientoPageState createState() => _MantenimientoPageState();
}

class _MantenimientoPageState extends State<MantenimientoPage> {
  final db = new Dbase();

  final _codigoController = new TextEditingController();
  final _descripcionController = new TextEditingController();
  final _precioController = new TextEditingController();

  @override
  void initState() {
    _codigoController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Mantenimiento')),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Codigo'),
              controller: _codigoController,
              cursorColor: Theme.of(context).accentColor,
              // maxLength: 6,
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Descripcion'),
              controller: _descripcionController,
              cursorColor: Theme.of(context).accentColor,
              // maxLength: 6,
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              decoration: InputDecoration(labelText: 'Precio'),
              controller: _precioController,
              cursorColor: Theme.of(context).accentColor,
              // maxLength: 6,
            ),
          ),
          SizedBox(height: 20),
          MaterialButton(
              child: Text('Guardar....', style: TextStyle(color: Colors.white)),
              onPressed: () {
                final plato = new PlatoModel(
                    codigo: _codigoController.text,
                    descripcion: _descripcionController.text,
                    precio: double.parse(_precioController.text));
                db.agregaPlato(plato);
                DataProvider.obtienePlatosProvider();
                Navigator.pop(context);
              },
              color: Colors.black87),
        ]));
  }
}