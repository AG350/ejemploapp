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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchPlato());
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: StreamBuilder(
        stream: DataProvider.streamController,
        // initialData: initialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return Container();

          final List<PlatoModel> lista = snapshot.data;
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (_, int index) {
              return ItemProducto(
                plato: lista[index],
                index: index,
              );
            },
          );
        },
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(
              "assets/no-image.png"), // no matter how big it is, it won't overflow
        ),
        title: Text(plato.descripcion),
      ),
    );
  }
}
