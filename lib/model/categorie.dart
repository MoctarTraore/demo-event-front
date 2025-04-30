class Categorie {
  final String nom;

  const Categorie(this.nom);

  @override
  String toString() => nom;

  factory Categorie.fromJson(String nom) {
    return Categorie(nom);
  }

  String toJson() => nom;
}