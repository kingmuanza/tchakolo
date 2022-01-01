class Palier {
  String? id;
  int? montant;
  int? delai;

  int? interet;

  Palier() {}

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'montant': montant,
      'delai': delai,
      'interet': interet,
    };
  }

  factory Palier.fromMap(Map<String, dynamic> map) {
    print("map");
    print(map);
    Palier palier = Palier();
    if (map['id'] != null) {
      palier.id = map['id'];
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

    return palier;
  }
}
