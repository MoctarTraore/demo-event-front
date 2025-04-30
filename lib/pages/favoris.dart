import 'package:flutter/material.dart';
import 'package:event/widgets/evenement_card.dart';
import 'package:event/model/evenement.dart';
import 'package:provider/provider.dart';

class FavorisPage extends StatelessWidget {
  const FavorisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoris = Provider.of<EvenementProvider>(context).favoris;

    return Scaffold(
      body: favoris.isEmpty
          ? const Center(
        child: Text("Aucun événement ajouté aux favoris."),
      )
          : ListView.builder(
        itemCount: favoris.length,
        itemBuilder: (context, index) {
          final evenement = favoris[index];
          return EvenementCard(evenement: evenement);
        },
      ),
    );
  }
}