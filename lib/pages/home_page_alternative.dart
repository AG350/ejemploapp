import 'dart:io';
import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/pages/pages.dart';
import 'package:ejemplo_app/pages/search/search_plato.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:ejemplo_app/utils/navigation_util.dart';
import 'package:ejemplo_app/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class HomePageAlternative extends StatefulWidget {
  static final String routeName = 'home_alt';
  @override
  _HomePageAlternativeState createState() => _HomePageAlternativeState();
}

class _HomePageAlternativeState extends State<HomePageAlternative> {
  List<PlatoModel> _carro = DataProvider.carritoTemporal;

  PlatoModel? platoSeleccionado;
  List<PlatoModel> historial = [];
  @override
  void initState() {
    DataProvider.obtienePlatosProvider(null);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista'),
        actions: [
          IconButton(
            onPressed: () async {
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
            },
            icon: Icon(Icons.search),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 36.0,
                  ),
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
              onTap: () {
                setState(() {});
                if (_carro.isNotEmpty)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CartPage(),
                    ),
                  );
              },
            ),
          )
        ],
      ),
      drawer: MenuWidget(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: DataProvider.streamController,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return Container();

            final List<PlatoModel> lista = snapshot.data;

            print(lista[0].imagen.toString());
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

  Widget _buildImage(PlatoModel plato) => plato.imagen != null
      ? Image.file(
          File(plato.imagen!),
          fit: BoxFit.cover,
          width: double.infinity,
          height: 120,
        )
      : Image(
          image: AssetImage('assets/no-image.png'),
          height: 120,
          width: double.infinity,
          fit: BoxFit.contain,
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