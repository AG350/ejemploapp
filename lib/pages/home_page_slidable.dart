
import 'package:flutter/material.dart';

import 'package:ejemplo_app/data/populate_data.dart';
import 'package:ejemplo_app/main.dart';
import 'package:ejemplo_app/models/models.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomePageSlide extends StatefulWidget {
  static final String routeName = 'home_slide';
  @override
  _HomePageSlideState createState() => _HomePageSlideState();
}

class _HomePageSlideState extends State<HomePageSlide> {
  List<PlatoModel> items = List.of(platos);
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = items[index];
            return Slidable(
              key: Key(item.nombre),
              actionPane: SlidableDrawerActionPane(),
              child: platoTile(item),
              actionExtentRatio: 0.20,
              actions: [
                IconSlideAction(
                  caption: 'Eliminar',
                  color: Colors.red,
                  icon: Icons.clear,
                  onTap: () => onDismissed(index, SlidableAction.eliminar),
                ),
                IconSlideAction(
                  caption: 'Editar',
                  color: Colors.yellow,
                  icon: Icons.edit,
                  onTap: () => onDismissed(index, SlidableAction.editar),
                ),
                IconSlideAction(
                  caption: 'Favoritos',
                  color: Colors.blue,
                  icon: Icons.favorite,
                  onTap: () => onDismissed(index, SlidableAction.favoritos),
                ),
                IconSlideAction(
                  caption: 'Ordenar',
                  color: Colors.green,
                  icon: Icons.add,
                  onTap: () => onDismissed(index, SlidableAction.ordenar),
                ),
                IconSlideAction(
                  caption: 'Compartir',
                  color: Colors.pink,
                  icon: Icons.share,
                  onTap: () => onDismissed(index, SlidableAction.compartir),
                ),
              ],
            );
          },
        ),
      );
  void onDismissed(int index, SlidableAction accion) {
    setState(() => items.removeAt(index));
    switch (accion) {
      case SlidableAction.compartir:
        AlertDialog(
          content: Text('jolsd'),
        );
        break;
      case SlidableAction.editar:
        break;
      case SlidableAction.eliminar:
        setState(() => items.removeAt(index));
        break;
      case SlidableAction.favoritos:
        break;
      case SlidableAction.ordenar:
        break;
      default:
    }
  }

  Widget platoTile(PlatoModel plato) => Builder(
        builder: (BuildContext context) => ListTile(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          leading: CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage('assets/no-image.png'),
          ),
          title: Text(
            plato.nombre,
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            final slidable = Slidable.of(context);
            final isClosed =
                slidable!.renderingMode == SlidableRenderingMode.none;
            if (isClosed) {
              slidable.open();
            } else {
              slidable.close();
            }
          },
        ),
      );
}

enum SlidableAction { ordenar, favoritos, compartir, eliminar, editar }
