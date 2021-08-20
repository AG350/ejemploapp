import 'dart:io';
import 'package:ejemplo_app/pages/search/search_plato.dart';
import 'package:ejemplo_app/widgets/menu_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:ejemplo_app/provider/data_provider.dart';

import 'package:ejemplo_app/main.dart';
import 'package:ejemplo_app/data/populate_data.dart';
import 'package:ejemplo_app/models/models.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<List<PlatoModel>> _platoStream = DataProvider.streamController;
  List<PlatoModel> _carro = DataProvider.carritoTemporal;
  PlatoModel? platoSeleccionado;
  List<PlatoModel> historial = [];
  int _selectedIndex = 0;
  @override
  void initState() {
    DataProvider.obtienePlatosProvider(null);
    super.initState();
  }

  void _onItemTapped(int index) async {
    switch (index) {
      case 1:
        final plato = await showSearch(
          context: context,
          delegate: SearchPlato('Buscar plato..', historial),
        );
        setState(
          () {
            if (plato != null) {
              platoSeleccionado = plato;
              historial.insert(0, plato);
            }
          },
        );
        break;
      case 2:
        Navigator.pushNamed(context, 'cart');
        break;
      case 1:
        break;
      default:
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  List<PlatoModel> items = List.of(platos);
  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          onTap: _onItemTapped, // new
          currentIndex: _selectedIndex, // new
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
            ),
            new BottomNavigationBarItem(
              icon: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Icon(Icons.shopping_cart),
                  if (_carro.length > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Text(
                          '${_carro.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Carro',
            )
          ],
        ),
        appBar: AppBar(
          title: Text(MyApp.title),
        ),
        drawer: MenuWidget(),
        body: StreamBuilder(
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
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Colors.red, Colors.green],
                              stops: [0.5, 0.5]),
                        ),
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    size: 35,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {}),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    size: 35,
                                  ),
                                  color: Colors.white,
                                  onPressed: () {}),
                            ),
                          ],
                        )),
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
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, 'mantenimiento'),
          child: Icon(Icons.add),
        ),
      );

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
            onTap: () => showDialog(
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
                      });
                      Navigator.of(context).pop(true);
                    },
                  ),
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
