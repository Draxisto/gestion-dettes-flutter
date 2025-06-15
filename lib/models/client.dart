import 'dette.dart';

class Client {
  final int id;
  final String nomComplet;
  final String telephone;
  final List<Dette> dettes;

  Client({
    required this.id,
    required this.nomComplet,
    required this.telephone,
    required this.dettes,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    var dettesList = (json['dettes'] as List)
        .map((dette) => Dette.fromJson(dette))
        .toList();

    return Client(
      id: json['id'],
      nomComplet: json['nomComplet'],
      telephone: json['telephone'],
      dettes: dettesList,
    );
  }
}
