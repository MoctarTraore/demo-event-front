import 'package:flutter/material.dart';
import 'package:event/model/evenement.dart';
import 'package:event/widgets/evenement_card.dart';
import 'package:provider/provider.dart';
import '../providers/categorie_provider.dart';
import 'package:event/model/categorie.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final Map<String, int> _nombreEvenementsParCategorie = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategorieProvider>(context, listen: false).fetchCategories();
    });
  }

  Future<void> _loadNombreEvenements(String categorie) async {
    try {
      final nombre = await Provider.of<EvenementProvider>(context, listen: false)
          .getNombreEvenementsParCategorie(categorie);
      setState(() {
        _nombreEvenementsParCategorie[categorie] = nombre;
      });
    } catch (e) {
      setState(() {
        _nombreEvenementsParCategorie[categorie] = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CategorieProvider>(
        builder: (context, categorieProvider, child) {
          if (categorieProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (categorieProvider.error != null) {
            return Center(child: Text('Erreur: ${categorieProvider.error}'));
          }

          final categories = categorieProvider.categories;

          return RefreshIndicator(
            onRefresh: () => categorieProvider.fetchCategories(),
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final categorie = categories[index];
                final nombreEvenements =
                    _nombreEvenementsParCategorie[categorie.nom] ?? 0;
                if (!_nombreEvenementsParCategorie.containsKey(categorie.nom)) {
                  _loadNombreEvenements(categorie.nom);
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EvenementsParCategoriePage(
                          categorie: categorie,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 90,
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              categorie.nom,
                              style: const TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            Text(
                              "$nombreEvenements évènement(s)",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class EvenementsParCategoriePage extends StatefulWidget {
  final Categorie categorie;

  const EvenementsParCategoriePage({super.key, required this.categorie});

  @override
  State<EvenementsParCategoriePage> createState() => _EvenementsParCategoriePageState();
}

class _EvenementsParCategoriePageState extends State<EvenementsParCategoriePage> {
  List<Evenement>? _evenements;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEvenements();
  }

  Future<void> _loadEvenements() async {
    try {
      final evenements = await Provider.of<EvenementProvider>(context, listen: false)
          .getEvenementsByCategorie(widget.categorie.nom);
      setState(() => _evenements = evenements);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_evenements == null && _error == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text("Événements - ${widget.categorie.nom}")),
        body: Center(child: Text('Erreur: $_error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Événements - ${widget.categorie.nom}"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
        onRefresh: _loadEvenements,
        child: ListView.builder(
          itemCount: _evenements!.length,
          itemBuilder: (context, index) {
            return EvenementCard(evenement: _evenements![index]);
          },
        ),
      ),
    );
  }
}