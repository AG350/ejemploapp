class UsuarioModel {
    UsuarioModel({
        this.id,
        required this.email,
        required this.nombre,
        required this.password,
    });

    int? id;
    String email;
    String nombre;
    String password;

    factory UsuarioModel.fromMap(Map<String, dynamic> json) => UsuarioModel(
        id: json["id"] == null ? null : json["id"],
        email: json["email"],
        nombre: json["nombre"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "email": email,
        "nombre": nombre,
        "password": password,
    };
}
