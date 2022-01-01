class Utilisateur {
  final int NON_IDENTIFIEE = 0;
  final int En_ATTENTE_VALIDATION = 1;
  final int VALIDE = 2;
  final int VALIDATION_EXPIREE = -1;
  final int VALIDATION_REJETEE = -2;

  String? id;
  String? noms;
  String? prenoms;
  DateTime? datenaiss;
  String? profession;
  String? pays;
  String? tel;
  String? ville;
  String? quartier;
  String? rue;
  String? passe;
  int statut = 0;

  Utilisateur(String tel, [int? stat]) {
    this.id = '237' + this.contactToIdentifiant(tel);
    this.tel = '237' + this.contactToIdentifiant(tel);
    if (stat != null) {
      statut = stat;
    }
  }

  String contactToIdentifiant(String numero) {
    return numero.split(' ').join('').split('-').join('');
  }

  generateID() {
    return '';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'noms': noms,
      'prenoms': prenoms,
      'datenaiss': datenaiss != null ? datenaiss!.toIso8601String() : null,
      'profession': profession,
      'pays': pays,
      'tel': tel,
      'ville': ville,
      'quartier': quartier,
      'rue': rue,
      'passe': passe,
      'statut': statut,
    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    Utilisateur u;

    if (map['tel'] != null) {
      u = Utilisateur(map['tel']);
      if (map['id'] != null) {
        u.id = map['id'];
      }
      if (map['noms'] != null) {
        u.noms = map['noms'];
      }
      if (map['prenoms'] != null) {
        u.prenoms = map['prenoms'];
      }
      if (map['datenaiss'] != null) {
        u.datenaiss = DateTime.parse(map['datenaiss']);
      }
      if (map['profession'] != null) {
        u.profession = map['profession'];
      }
      if (map['pays'] != null) {
        u.pays = map['pays'];
      }
      if (map['tel'] != null) {
        u.tel = map['tel'];
      }
      if (map['ville'] != null) {
        u.ville = map['ville'];
      }
      if (map['quartier'] != null) {
        u.quartier = map['quartier'];
      }
      if (map['rue'] != null) {
        u.rue = map['rue'];
      }
      if (map['passe'] != null) {
        u.passe = map['passe'];
      }
      if (map['statut'] != null) {
        u.statut = map['statut'];
      } else {
        u.statut = 0;
      }
    } else {
      return u = new Utilisateur('');
    }
    return u;
  }
}
