class Utilisateur {
  int id;
  String nom;
  String email;
  String telephone;
  String adresse;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.email,
    required this.telephone,
    required this.adresse,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) {
    return Utilisateur(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      telephone: json['telephone'],
      adresse: json['adresse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'telephone': telephone,
      'adresse': adresse,
    };
  }
}
