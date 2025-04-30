import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../model/evenement.dart';

class GenererQrPage extends StatelessWidget {
  const GenererQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    final evenements = context.watch<EvenementProvider>().evenements;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Générer QR Code'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemCount: evenements.length,
        itemBuilder: (context, index) {
          final evenement = evenements[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text(evenement.nom),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      QrImageView(
                        data: evenement.nom,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Sauvegarder'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}