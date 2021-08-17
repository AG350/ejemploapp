// To parse this JSON data, do
//
//     final platoModel = platoModelFromJson(jsonString);

import 'dart:convert';

PlatoModel platoModelFromJson(String str) =>
    PlatoModel.fromJson(json.decode(str));

String platoModelToJson(PlatoModel data) => json.encode(data.toJson());

class PlatoModel {
  PlatoModel({
    this.id,
    required this.codigo,
    required this.descripcion,
    this.imagen,
    required this.precio,
  });

  int? id;
  String codigo;
  String descripcion;
  String? imagen;
  double precio;

  factory PlatoModel.fromJson(Map<String, dynamic> json) => PlatoModel(
        id: json["id"],
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        imagen: json["imagen"],
        precio: json["Precio"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigo": codigo,
        "descripcion": descripcion,
        "imagen": descripcion,
        "Precio": precio,
      };
}
