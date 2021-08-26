import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/utils/snack_bar_util.dart';
import 'package:ejemplo_app/widgets/widgets.dart';

class MantenimientoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///TODO La estructura de widgets esta bien pero es conveniente separar en widgets mas pequeños para que sea mas legible
    ///ejemplo un widget para el formulario, otro para camara y galeria
    return Scaffold(
      appBar: AppBar(title: Text('Mantenimiento')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  FormNewEditPlato(),
                ],
              )),
        ),
      ),
    );
  }

  /// Get from camera
}

class FormNewEditPlato extends StatelessWidget {
  final _codigoController = new TextEditingController();
  final _nombreController = new TextEditingController();
  final _descripcionController = new TextEditingController();
  final _precioController = new TextEditingController();
  String _opt = 'nuevo';
  File? image;
  PlatoModel? platoEdit;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlatoModel>(
      stream: DataProvider.platoEditstreamController,
      initialData: DataProvider.platoEditar,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          this.platoEdit = DataProvider.platoEditar!;
          _codigoController.text = platoEdit!.codigo;
          _nombreController.text = platoEdit!.nombre;
          _descripcionController.text = platoEdit!.descripcion;
          _precioController.text = platoEdit!.precio.toString();
          image = platoEdit!.imagen == null
              ? null
              : File(
                  platoEdit!.imagen.toString(),
                );
          _opt = 'actualizar';
        } else {
          _codigoController.text = '';
          _nombreController.text = '';
          _descripcionController.text = '';
          _precioController.text = '';
        }

        return Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                height: 200,
                width: 250,
                child: image != null ? Image(image: FileImage(image!)) : Image(image: AssetImage('assets/no-image.png')),
              ),
              CustomFormField(
                label: 'Codigo',
                controller: _codigoController,
                iconData: Icons.info,
              ),
              SizedBox(height: 10),
              CustomFormField(label: 'Nombre', controller: _nombreController, iconData: Icons.dashboard_outlined),
              SizedBox(height: 10),
              CustomFormField(label: 'Descripcion', controller: _descripcionController, iconData: Icons.description),
              SizedBox(height: 10),
              CustomFormField(label: 'Precio', controller: _precioController, iconData: Icons.attach_money, type: TextInputType.number),
              ImagSource(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                SubmitButton(
                  label: 'Guardar',
                  opt: _opt,
                  plato: new PlatoModel(
                      codigo: _codigoController.text,
                      nombre: _nombreController.text,
                      descripcion: _descripcionController.text,
                      precio: double.parse(_precioController.text),
                      imagen: DataProvider.platoEditar?.imagen ?? null),
                ),
                SubmitButton(label: 'Cancelar', opt: 'cancelar', plato: platoEdit),
              ]),
            ],
          ),
        );
      },
    );
  }
}

class ImagSource extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      if (imageFromSource != null) {
                        PlatoModel? plato = DataProvider.platoEditar;
                        plato!.imagen = imageFromSource.path;
                        DataProvider.cargarPlatoEditarProvider(plato);
                      }
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
                      if (imageFromSource != null) {
                        PlatoModel? plato = DataProvider.platoEditar;
                        plato!.imagen = imageFromSource.path;
                        DataProvider.cargarPlatoEditarProvider(plato);
                      }
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
    );
  }
}

class SubmitButton extends StatelessWidget {
  final String opt;
  final String label;
  final PlatoModel? plato;
  final db = new Dbase();

  SubmitButton({required this.opt, this.plato, required this.label});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if (opt == 'actualizar') {
            print('actualizar: ${plato?.nombre}');
            db.modificaPlato(plato!);
            DataProvider.obtienePlatosProvider();
            DataProvider.platoEditar = null;
            Navigator.pop(context);
            Utils.showSnackBar(context, 'Edicion exitosa');
            return;
          } else if (opt == 'cancelar') {
            DataProvider.platoEditar = null;
            Navigator.pop(context);
            Utils.showSnackBar(context, 'Cancelado');
            return;
          } else {
            db.agregaPlato(plato!);
            DataProvider.platoEditar = null;
            DataProvider.obtienePlatosProvider();
            Navigator.pop(context);
            Utils.showSnackBar(context, 'Creacion exitosa');
            return;
          }
        },
        color: Colors.black87);
  }
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
