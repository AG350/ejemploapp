import 'package:ejemplo_app/models/plato_model.dart';
import 'package:ejemplo_app/provider/data_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, 'mantenimiento');
            },
            icon: Icon(Icons.add),
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
              return Dismissible(
                key: Key('${lista[index].descripcion}-prodDis'),
                onDismissed: (DismissDirection direction){
                  
                },
                child: ListTile(
                  leading: Text(lista[index].descripcion),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
