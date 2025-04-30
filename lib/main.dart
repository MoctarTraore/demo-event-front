import 'package:event/pages/ajouterEvenement.dart';
import 'package:flutter/material.dart';
import 'package:event/pages/favoris.dart';
import 'package:event/pages/home.dart';
import 'package:event/pages/rechercher.dart';
import 'package:event/pages/profile.dart';
import 'package:event/pages/evenements.dart';
import 'package:event/pages/categories.dart';
import 'package:provider/provider.dart';
import 'model/evenement.dart';
import 'package:event/providers/categorie_provider.dart';
import 'package:event/providers/utilisateur_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:event/pages/scan.dart';
import 'package:event/pages/generer_qr.dart';

void main() {
  runApp( 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EvenementProvider()),
        ChangeNotifierProvider(create: (_) => CategorieProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final utilisateurProvider = UtilisateurProvider();
            utilisateurProvider.fetchUtilisateurConnecte(); 
            return utilisateurProvider;
          },
        ),
      ],
      child: const EvenementApp(),
    ),
  );
}

class EvenementApp extends StatelessWidget {
  const EvenementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('fr'),
      supportedLocales: const [ Locale('fr') ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'Événements',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PagePrincipale(),
    );
  }
}

class PagePrincipale extends StatefulWidget {
  const PagePrincipale({super.key});

  @override
  State<PagePrincipale> createState() => _PagePrincipaleState();
}

class _PagePrincipaleState extends State<PagePrincipale> {
  int _selectedIndex = 0;
  final TextEditingController _rechercherController = TextEditingController();
  List<Evenement> _evenementsFiltre = [];

  final List<Widget> _pages = [
    const HomePage(),
    const CategoriesPage(),
    const FavorisPage(),
    Container(),
    const ProfilePage(),
    const EvenementsPage(),
  ];

  final List<String> _titres = [
    "Événements",
    "Catégories",
    "Favoris",
    "Rechercher",
    "Profil",
    "Mes Événements",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
        final tousLesEvenements = context.read<EvenementProvider>().evenements;
        _evenementsFiltre = List.from(tousLesEvenements);
      } else {
        _evenementsFiltre.clear();
        _rechercherController.clear();
      }
    });
  }

  void filtrerEvenements(String query) {
    final tousLesEvenements = context.read<EvenementProvider>().evenements;
    setState(() {
      if (query.isEmpty) {
        _evenementsFiltre = List.from(tousLesEvenements);
      } else {
        _evenementsFiltre = tousLesEvenements
            .where((evenement) =>
                evenement.nom.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    // final tousLesEvenements = context.watch<EvenementProvider>().evenements;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _selectedIndex == 3
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _rechercherController,
                      decoration: const InputDecoration(
                        hintText: 'Rechercher...',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (query) {
                        filtrerEvenements(query);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: () async {
                      final scannedText = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QrScanPage()),
                      );
                      if (scannedText != null) {
                        _rechercherController.text = scannedText;
                        filtrerEvenements(scannedText);
                      }
                    },
                  ),
                ],
              )
            : Text(_titres[_selectedIndex]),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      endDrawer: Drawer(
        child: Consumer<UtilisateurProvider>(
          builder: (context, utilisateurProvider, child) {
            if (utilisateurProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (utilisateurProvider.error != null) {
              return Center(child: Text('Erreur : ${utilisateurProvider.error}'));
            }

            final utilisateur = utilisateurProvider.utilisateur;

            return ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(color: Colors.deepPurple),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        utilisateur?.nom ?? 'Utilisateur',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profil'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Mes événements'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIndex = 5;
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.qr_code),
                  title: const Text('Générer QR Codes'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GenererQrPage(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
      body: _selectedIndex == 3
          ? RechercherPage(evenementsFiltre: _evenementsFiltre)
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Catégories'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoris'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Rechercher'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AjouterEvenementPage()
            ));
          },
          child: Icon(Icons.add),
      ),
    );
  }
}
