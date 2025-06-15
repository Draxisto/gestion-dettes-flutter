import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart';
import '../models/dette.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.100:3000';

  //Lister les clients
  static Future<List<Client>> fetchClients() async {
    final response = await http.get(Uri.parse('$baseUrl/clients'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Client.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des clients');
    }
  }

  //Détails d’un client (avec dettes)
  static Future<Client> fetchClientById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/clients/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Client.fromJson(data);
    } else {
      throw Exception('Client non trouvé');
    }
  }

  //Ajouter une dette à un client
  static Future<void> ajouterDette(int clientId, Dette nouvelleDette) async {
    // Récupérer d’abord le client actuel
    Client client = await fetchClientById(clientId);

    // Ajouter la nouvelle dette à la liste existante
    List<Dette> updatedDettes = List.from(client.dettes)..add(nouvelleDette);

    // Mise à jour du client
    final response = await http.patch(
      Uri.parse('$baseUrl/clients/$clientId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'dettes': updatedDettes.map((d) => d.toJson()).toList(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de l’ajout de la dette');
    }
  }
}
