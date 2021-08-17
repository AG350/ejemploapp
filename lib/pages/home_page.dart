import 'dart:io';

import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/pages/search/search_plato.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  delegate: SearchPlato('Buscar plato..', historial));
              setState(() {
                if (plato != null) {
                  this.platoSeleccionado = plato;
                  this.historial.insert(0, plato);
                }
              });
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
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
                print('aca ${lista[index].imagen}');
                return ItemProducto(
                  plato: lista[index],
                  index: index,
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
}

class ItemProducto extends StatelessWidget {
  ItemProducto({
    Key? key,
    required this.plato,
    required this.index,
  }) : super(key: key);

  final PlatoModel plato;
  final int index;
  final db = new Dbase();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('${plato.codigo}-prodDis'),
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
        DataProvider.eliminarPlatoPorId(plato.id!);
      },
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Eliminar plato'),
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
              children: [_buildImage(plato), _buildText(context, plato)],
            ),
          ),
        ),
      ),
    );
  }

  /*
  ListTile(
          title: Text(plato.descripcion),
          subtitle: Text('${plato.precio}'),
          onTap: () => print(plato.descripcion),
        ),
   */
  Widget _buildImage(PlatoModel plato) => Image.file(
        File(plato.imagen!),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 120,
      );
  Widget _buildText(BuildContext context, PlatoModel palto) => ExpansionTile(
        childrenPadding: EdgeInsets.all(16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text(
          '${plato.nombre}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        children: [
          Text(
            'Precio:  \$${plato.precio}',
            style: TextStyle(
                fontSize: 22, height: 1.4, fontWeight: FontWeight.w500),
          ),
          Text(
            'Descripcion:  ${plato.descripcion}',
            style: TextStyle(fontSize: 18, height: 1.4),
          ),
          BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined), label: 'Agregar'),
              BottomNavigationBarItem(icon: Icon(Icons.clear), label: 'Volver'),
            ],
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          )
        ],
      );
}
