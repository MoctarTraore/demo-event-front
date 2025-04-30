import 'package:flutter/material.dart';
import 'package:event/model/evenement.dart';
import 'package:event/widgets/evenement_card.dart';

class RechercherPage extends StatefulWidget {
  final List<Evenement> evenementsFiltre;

  const RechercherPage({super.key, required this.evenementsFiltre});

  @override
  State<RechercherPage> createState() => _RechercherPageState();
}

class _RechercherPageState extends State<RechercherPage> {


  @override
  Widget build(BuildContext context) {
    final filteredEvents = widget.evenementsFiltre;

    return Scaffold(
      
      body: Column(
        children: [
          Expanded(
            child: filteredEvents.isEmpty
                ? const Center(
                    child: Text(
                      'Aucun événement trouvé.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final evenement = filteredEvents[index];
                      return EvenementCard(evenement: evenement);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
