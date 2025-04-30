 import 'dart:io';

import 'package:flutter/material.dart';
import 'package:event/model/evenement.dart';
import 'package:event/pages/evenementDetails.dart';
import 'package:provider/provider.dart';

 class EvenementCard extends StatelessWidget {
   final Evenement evenement;

   const EvenementCard({super.key, required this.evenement});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<EvenementProvider>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EvenementDetailsPage(evenement: evenement),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              child: evenement.isAsset
                  ? Image.asset(
                evenement.imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              )
                  : Image.file(
                File(evenement.imageUrl),
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    evenement.nom,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(
                      evenement.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: evenement.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      provider.toggleFavorite(evenement);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    evenement.lieu,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    evenement.getFormattedDate(),
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      evenement.categorie,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
