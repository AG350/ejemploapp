///TODO Intentar mantener orden en importaciones de directorios.
///Primero las propias de dart, despues la de flutter, dependecias de terceros y por ultimo las importaciones de otras clases
import 'package:flutter/material.dart';

import 'package:ejemplo_app/provider/data_provider.dart';

///TODO esto no es necesario que sea un statefulWidget con un StatelessWidget y un StreamBuilder podes escuchar los cambios  de
///carroStream
class CartCounterItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: DataProvider.carritoTemporal.length,
        stream: DataProvider.cantidadCarroStream,
        builder: (context, snapshot) {
          return Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Icon(Icons.shopping_cart),
              if (snapshot.hasData && snapshot.data != 0)
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: CircleAvatar(
                    radius: 8.0,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    child: Text(
                      '${snapshot.data ?? ''}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ),
            ],
          );
        });
  }
}
