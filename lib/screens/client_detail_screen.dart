import 'package:flutter/material.dart';
import '../models/client.dart';
import '../models/dette.dart';
import '../services/api_service.dart';

class ClientDetailScreen extends StatefulWidget {
  final Client client;

  const ClientDetailScreen({super.key, required this.client});

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  late Client client;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    client = widget.client;
  }

  Future<void> _refreshClient() async {
    setState(() => isLoading = true);
    try {
      client = await ApiService.fetchClientById(client.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors du rafraîchissement : $e")));
    }
    setState(() => isLoading = false);
  }

  void _showAddDetteDialog() {
    final _montantController = TextEditingController();
    final _dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter une dette"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _montantController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Montant"),
            ),
            TextField(
              controller: _dateController,
              decoration:
                  const InputDecoration(labelText: "Date (YYYY-MM-DD)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _montantController.dispose();
              _dateController.dispose();
            },
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final montant = double.tryParse(_montantController.text);
              final date = _dateController.text.trim();

              if (montant == null || date.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Veuillez remplir correctement les champs")),
                );
                return;
              }

              final nouvelleDette = Dette(
                id: client.dettes.isNotEmpty
                    ? client.dettes.map((d) => d.id).reduce((a, b) => a > b ? a : b) + 1
                    : 1,
                montant: montant,
                date: date,
              );

              Navigator.pop(context);
              setState(() => isLoading = true);

              try {
                await ApiService.ajouterDette(client.id, nouvelleDette);
                await _refreshClient();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erreur : $e")),
                );
              }

              setState(() => isLoading = false);

              _montantController.dispose();
              _dateController.dispose();
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(client.nomComplet),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshClient,
              child: client.dettes.isEmpty
                  ? const Center(child: Text("Pas de dettes pour ce client"))
                  : ListView.builder(
                      itemCount: client.dettes.length,
                      itemBuilder: (context, index) {
                        final dette = client.dettes[index];
                        return ListTile(
                          leading: const Icon(Icons.money_off),
                          title: Text("${dette.montant.toStringAsFixed(2)} FCFA"),
                          subtitle: Text("Date : ${dette.date}"),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDetteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
