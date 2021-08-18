import 'dart:io';
import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/pages/search/search_plato.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/utils/navigation_util.dart';
import 'package:ejemplo_app/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

Stream<List<PlatoModel>> _cartStream = DataProvider().carroStream();
PlatoModel? platoSeleccionado2;
List<PlatoModel> historial = [];
List<PlatoModel> _carro = [];

class HomePage2 extends StatefulWidget {
  static final String routeName = 'home';
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  @override
  void initState() {
    DataProvider.obtienePlatosProvider(null);
    _cartStream.listen((carro) {
      _carro = carro;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista'),
        centerTitle: true,
      ),
      drawer: MenuWidget(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: DataProvider.streamController,
          // initialData: initialData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return Container();

            final List<PlatoModel> lista = snapshot.data;
            return ListView.builder(
              itemCount: lista.length,
              itemBuilder: (_, int index) {
                return Dismissible(
                  key: Key('${lista[index].codigo}-prodDis'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    padding: EdgeInsets.only(left: 20),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  onDismissed: (_) {
                    DataProvider.eliminarPlatoPorId(lista[index].id!);
                  },
                  confirmDismiss: (_) {
                    return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Eliminar lista plato'),
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
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.black, width: 2)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            _buildImage(lista[index]),
                            _buildText(context, lista[index])
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'mantenimiento'),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildImage(PlatoModel plato) => Image.file(
        File(plato.imagen!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 120,
      );
  Widget _buildText(BuildContext context, PlatoModel plato) => ExpansionTile(
        childrenPadding: EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text(
          '${plato.nombre}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Precio:  \$${plato.precio}',
          style:
              TextStyle(fontSize: 22, height: 1.4, fontWeight: FontWeight.w500),
        ),
        children: [
          Text(
            'Descripcion:  ${plato.descripcion}',
            style: TextStyle(fontSize: 18, height: 1.4),
          ),
          BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Agregar',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.clear), label: 'Volver'),
            ],
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (int index) {
              if (index == 0) {
                setState(() {
                  DataProvider.agregarItemCarrito(plato);
                });

                return;
              }
              NavigationService.instance.navigateToReplacement("home");
            },
          )
        ],
      );
}
