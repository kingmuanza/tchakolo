import 'package:tchakolo/models/utilisateur.model.dart';

class DemandeCredit {
  String? id;
  String? idutilisateur;
  int? statut;
  int? montant;
  int? delai;
  int? interet;
  DateTime? dateDemande;
  DateTime? dateRecue;

  DemandeCredit(Utilisateur? utilisateur) {
    if (utilisateur != null) {
      idutilisateur = utilisateur.id!;
      id = utilisateur.id! +
          '-' +
          DateTime.now().millisecondsSinceEpoch.toString();
    }
    dateDemande = DateTime.now();
    statut = 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idutilisateur': idutilisateur,
      'statut': statut,
      'montant': montant,
      'delai': delai,
      'interet': interet,
      'dateDemande':
          dateDemande != null ? dateDemande!.toIso8601String() : null,
      'dateRecue': dateRecue != null ? dateRecue!.toIso8601String() : null,
    };
  }

  factory DemandeCredit.fromMap(Map<String, dynamic> map) {
    print("map");
    print(map);
    DemandeCredit palier = DemandeCredit(null);
    if (map['id'] != null) {
      palier.id = map['id'];
    }
    if (map['idutilisateur'] != null) {
      palier.idutilisateur = map['idutilisateur'];
    }
    if (map['statut'] != null) {
      palier.statut = map['statut'];
    }
    if (map['montant'] != null) {
      palier.montant = map['montant'];
    }
    if (map['delai'] != null) {
      palier.delai = map['delai'];
    }
    if (map['interet'] != null) {
      palier.interet = map['interet'];
    }
    if (map['dateDemande'] != null) {
      palier.dateDemande = DateTime.parse(map['dateDemande']);
    }
    if (map['dateRecue'] != null) {
      palier.dateRecue = DateTime.parse(map['dateRecue']);
    }

    return palier;
  }
}
