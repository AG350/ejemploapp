import 'package:ejemplo_app/data/dbase.dart';
import 'package:ejemplo_app/models/models.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';

class SearchPlato extends SearchDelegate {
  @override
  final String searchFieldLabel;
  final List<PlatoModel> historial;

  SearchPlato(this.searchFieldLabel, this.historial);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () => this.close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.trim().length == 0) {
      return Text('no hay valor en el query');
    }

    final db = new Dbase();
    // query!
    return FutureBuilder(
      future: db.leePlatoByTermino(query),
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return ListTile(title: Text('No hay nada con ese término'));
        }

        if (snapshot.hasData) {
          // crear la lista
          return _showPlatos(snapshot.data);
        } else {
          // Loading
          return Center(child: CircularProgressIndicator(strokeWidth: 4));
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _showPlatos(this.historial);
  }

  Widget _showPlatos(List<PlatoModel> platos) {
    return ListView.builder(
      itemCount: platos.length,
      itemBuilder: (context, i) {
        final plato = platos[i];

        return ListTile(
          title: Text(plato.descripcion),
          subtitle: Text('${plato.imagen}'),
          onTap: () {
            DataProvider.obtienePlatosProvider(plato);
            this.close(context, plato);
          },
        );
      },
    );
  }
}