import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:ejemplo_app/provider/data_provider.dart';

import 'package:ejemplo_app/data/populate_data.dart';
import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/widgets/widgets.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<List<PlatoModel>> _platoStream = DataProvider.streamController;
  List<PlatoModel> _carro = DataProvider.carritoTemporal;
  @override
  void initState() {
    DataProvider.obtienePlatosProvider();
    super.initState();
  }

  List<PlatoModel> items = List.of(platos);
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('Platos de comida')),
      drawer: MenuWidget(),
      body: _bodyBuilder(),
      floatingActionButton: FloatingNewPlato(),
      bottomNavigationBar: BottomNavigationCustom(
        carro: _carro,
      ));

  StreamBuilder<List<PlatoModel>> _bodyBuilder() {
    return StreamBuilder(
      stream: _platoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final List<PlatoModel> items = snapshot.data;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = items[index];
              return Dismissible(
                dragStartBehavior: DragStartBehavior.down,
                key: Key('${item.codigo}-prodDis'),
                background: Container(
                    decoration: itemBackgroundDecoration(),
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: ItemOptionsIcons()),
                onDismissed: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    DataProvider.eliminarPlatoPorId(item.id!);
                  } else {
                    Navigator.pushNamed(context, 'mantenimiento',
                        arguments: item);
                  }
                },
                confirmDismiss: (direction) {
                  if (direction == DismissDirection.startToEnd) {
                    return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Eliminar plato del listado'),
                        content: Text(
                          'Confirma la eliminacion?',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('Si'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  return showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Editar plato'),
                      content: Text(
                        'Desea editar este plato?',
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('Si'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                            Navigator.pushNamed(context, 'mantenimiento',
                                arguments: item);
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: platoTile(item),
              );
            },
          );
        }
        return Container(
          height: 400,
          width: double.infinity,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  BoxDecoration itemBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.red, Colors.green],
          stops: [0.5, 0.5]),
    );
  }

  Widget platoTile(PlatoModel plato) => Builder(
        builder: (BuildContext context) => Container(
          padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 5),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(0),
              width: 60,
              child: plato.imagen != null
                  ? Image.file(File(plato.imagen.toString()))
                  : Image(image: AssetImage('assets/no-image.png')),
            ),
            title: Text(
              plato.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Precio: ${plato.precio}',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(
                  plato.descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            onTap: () => popUpItem(context, plato),
          ),
        ),
      );

  Future<dynamic> popUpItem(BuildContext context, PlatoModel plato) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(plato.nombre),
        content: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: plato.imagen != null
                  ? Image.file(File(plato.imagen.toString()))
                  : Image(image: AssetImage('assets/no-image.png')),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Precio: ${plato.precio}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${plato.descripcion}',
            ),
          ],
        ),
        elevation: 0,
        scrollable: true,
        actions: <Widget>[
          TextButton(
            child: Text('Ordenar'),
            onPressed: () {
              setState(() {
                DataProvider.agregarItemCarrito(plato);
                DataProvider.obtienePlatosProvider();
              });
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              DataProvider.obtienePlatosProvider();
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }
}

class ItemOptionsIcons extends StatelessWidget {
  const ItemOptionsIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Icon(Icons.delete, color: Colors.white),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.edit, color: Colors.white),
        ),
      ],
    );
  }
}

class FloatingNewPlato extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, 'mantenimiento'),
      child: Icon(Icons.add),
    );
  }
}
