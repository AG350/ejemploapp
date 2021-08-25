import 'dart:io';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MantenimientoPage extends StatefulWidget {
  @override
  _MantenimientoPageState createState() => _MantenimientoPageState();
}

class _MantenimientoPageState extends State<MantenimientoPage> {
  final db = new Dbase();
  bool guardar = false;
  bool noRepetirRender = true;

  var _codigoController = new TextEditingController();
  var _nombreController = new TextEditingController();
  var _descripcionController = new TextEditingController();
  var _precioController = new TextEditingController();
  File? image;
  late PlatoModel platoEdit;

  @override
  void initState() {
    _codigoController.text = '';
    _nombreController.text = '';
    _descripcionController.text = '';
    _precioController.text = '';

    super.initState();
  }

  ///TODO Siempre poner el dispose para los controller para no generar perdida de memoria
  @override
  void dispose() {
    _codigoController.dispose();
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      if (noRepetirRender) {
        ///TODO se puede guardar el plato seleccionado en el provider para evitar pasar informacion entre ventanas con el navigator
        ///de este modo se tiene mas centralizado la logica
        platoEdit = ModalRoute.of(context)!.settings.arguments as PlatoModel;
        if (platoEdit.codigo.isNotEmpty) {
          setState(() {
            print('set: ${platoEdit.imagen}');
            _codigoController.text = platoEdit.codigo;
            _nombreController.text = platoEdit.nombre;
            _descripcionController.text = platoEdit.descripcion;
            _precioController.text = platoEdit.precio.toString();
            image = platoEdit.imagen == null
                ? null
                : File(platoEdit.imagen.toString());
            guardar = true;
          });
        }
        noRepetirRender = false;
      }
    } catch (e) {}

    ///TODO La estructura de widgets esta bien pero es conveniente separar en widgets mas pequeños para que sea mas legible
    ///ejemplo un widget para el formulario, otro para camara y galeria
    return Scaffold(
      appBar: AppBar(title: Text('Mantenimiento')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25)),
                  height: 200,
                  width: 250,
                  child: image != null
                      ? Image(image: FileImage(image!))
                      : Image(
                          image: AssetImage('assets/no-image.png'),
                        ),
                ),
                _FormsFields(
                  textControler: _codigoController,
                  label: 'Codigo',
                  tipo: TextInputType.text,
                ),
                SizedBox(height: 10),
                _FormsFields(
                  textControler: _nombreController,
                  label: 'Nombre',
                  tipo: TextInputType.name,
                ),
                SizedBox(height: 10),
                _FormsFields(
                  textControler: _descripcionController,
                  label: 'Descripcion',
                  tipo: TextInputType.multiline,
                ),
                SizedBox(height: 10),
                _FormsFields(
                  textControler: _precioController,
                  label: 'Precio',
                  tipo: TextInputType.number,
                ),
                SizedBox(height: 40),
                Text('Seleccionar foto desde...'),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            IconButton(
                              tooltip: 'Galeria',
                              onPressed: () {
                                _getFrom('galeria').then((imageFromSource) {
                                  setState(() {
                                    this.image = File(imageFromSource!.path);
                                  });
                                });
                              },
                              icon: Icon(Icons.photo_album),
                            ),
                            Text('Galeria'),
                          ],
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Column(
                          children: [
                            IconButton(
                              tooltip: 'Camara',
                              onPressed: () {
                                _getFrom('camara').then((imageFromSource) {
                                  setState(() {
                                    this.image = File(imageFromSource!.path);
                                  });
                                });
                              },
                              icon: Icon(Icons.camera_sharp),
                            ),
                            Text('Camara'),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                MaterialButton(
                    child: Text(
                      'Guardar....',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_codigoController.text != '' &&
                          _nombreController.text != '' &&
                          _descripcionController.text != '' &&
                          _precioController.text != '') {
                        if (guardar) {
                          platoEdit.codigo = _codigoController.text;
                          platoEdit.nombre = _nombreController.text;
                          platoEdit.descripcion = _descripcionController.text;
                          platoEdit.precio =
                              double.parse(_precioController.text);
                          platoEdit.imagen = image == null
                              ? null
                              : this.image?.path.toString();
                          db.modificaPlato(platoEdit);
                          DataProvider.obtienePlatosProvider();
                          Navigator.pop(context);
                          return;
                        }
                        final platoNuevo = new PlatoModel(
                          codigo: _codigoController.text,
                          nombre: _nombreController.text,
                          descripcion: _descripcionController.text,
                          precio: double.parse(_precioController.text),
                          imagen: this.image?.path.toString() ?? null,
                        );
                        db.agregaPlato(platoNuevo);
                        DataProvider.obtienePlatosProvider();
                        Navigator.pop(context);
                      } else {
                        SnackBar snackBar =
                            SnackBar(content: Text('Cancelado'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        Navigator.pop(context);
                      }
                    },
                    color: Colors.black87),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<XFile?> _getFrom(String opt) async {
    if (opt == 'camara') {
      final picker = new ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      if (pickedFile == null) {
        return null;
      }
      return pickedFile;
    } else {
      final picker = new ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (pickedFile == null) {
        return null;
      }
      print('path de la foto: ${pickedFile.path.toString()}');
      return pickedFile;
    }
  }

  /// Get from camera
}

class _FormsFields extends StatelessWidget {
  const _FormsFields({
    required this.label,
    required this.textControler,
    required this.tipo,
  });

  final TextEditingController textControler;
  final String label;
  final TextInputType tipo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        keyboardType: tipo,
        decoration: InputDecoration(labelText: label),
        controller: textControler,
        cursorColor: Theme.of(context).accentColor,
      ),
    );
  }
}
