import 'package:flutter/material.dart';
import 'clients_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Principal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ClientsListScreen()));
              },
              child: const Text('Lister les Clients'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Fonctionnalité "Lister les Dettes d\'un Client" à utiliser via la liste clients')),
                );
              },
              child: const Text('Lister les Dettes d\'un Client'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Utiliser l\'écran client pour ajouter une dette')),
                );
              },
              child: const Text('Ajouter une Dette à un Client'),
            ),
          ],
        ),
      ),
    );
  }
}
