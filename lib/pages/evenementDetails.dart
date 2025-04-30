import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:event/model/evenement.dart';

class EvenementDetailsPage extends StatelessWidget {
  final Evenement evenement;

  const EvenementDetailsPage({super.key, required this.evenement});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EvenementProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          evenement.nom,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              evenement.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: evenement.isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: () {
              provider.toggleFavorite(evenement);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            evenement.isAsset
                ? Image.asset(evenement.imageUrl)
                : Image.file(
                    File(evenement.imageUrl),
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    evenement.nom,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(evenement.lieu),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(evenement.getFormattedDate()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    evenement.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),





                  if (evenement.signature != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Signature :",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Container(
                            width: 200,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Image.memory(
                              base64Decode(evenement.signature!),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
}
