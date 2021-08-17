import 'dart:io';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MantenimientoPage extends StatefulWidget {
  @override
  _MantenimientoPageState createState() => _MantenimientoPageState();
}

class _MantenimientoPageState extends State<MantenimientoPage> {
  final db = new Dbase();

  final _codigoController = new TextEditingController();
  final _nombreController = new TextEditingController();
  final _descripcionController = new TextEditingController();
  final _precioController = new TextEditingController();
  final _imageController = new TextEditingController();
  File? image;

  @override
  void initState() {
    _codigoController.text = '';
    _nombreController.text = '';
    _descripcionController.text = '';
    _precioController.text = '';
    _imageController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mantenimiento')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 250,
              width: 250,
              child: image != null
                  ? Image(image: FileImage(image!))
                  : Image(
                      image: AssetImage('assets/no-image.png'),
                    ),
            ),
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
                decoration: InputDecoration(labelText: 'Nombre'),
                controller: _nombreController,
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
            // SizedBox(height: 10),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 20),
            //   child: TextFormField(
            //     decoration: InputDecoration(labelText: 'URL imagen'),
            //     controller: _imageController,
            //     cursorColor: Theme.of(context).accentColor,
            //     // maxLength: 6,
            //   ),
            // ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(15),
              child: MaterialButton(
                  onPressed: () async {
                    final picker = new ImagePicker();
                    final XFile? pickedFile = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 100,
                    );
                    if (pickedFile == null) {
                      print('no selecciono nada');
                      return;
                    }

                    print('Tenemos imagen ${pickedFile.path}');
                    setState(() {
                      this.image = File(pickedFile.path);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.blue, width: 1, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Text('Seleccionar Imagen'),
                        Icon(Icons.camera)
                      ],
                    ),
                  )),
            ),
            SizedBox(height: 20),
            MaterialButton(
                child: Text(
                  'Guardar....',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  print('escaneado ${this._imageController.text}');
                  final plato = new PlatoModel(
                      codigo: _codigoController.text,
                      nombre: _nombreController.text,
                      descripcion: _descripcionController.text,
                      precio: double.parse(_precioController.text),
                      imagen: this.image?.path.toString());
                  db.agregaPlato(plato);
                  DataProvider.obtienePlatosProvider(null);
                  Navigator.pop(context);
                },
                color: Colors.black87),
          ],
        ),
      ),
    );
  }
}
