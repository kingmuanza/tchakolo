import 'package:tchakolo/models/utilisateur.model.dart';

class Piece {
  String? id;
  String? numero;
  String? type;
  DateTime? dateExpiration;
  String? url;

  Piece([Utilisateur? utilisateur]) {
    if (utilisateur != null) {
      this.id = utilisateur.id;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'type': type,
      'url': url,
      'dateExpiration':
          dateExpiration != null ? dateExpiration!.toIso8601String() : null,
    };
  }

  factory Piece.fromMap(Map<String, dynamic> map) {
    Piece piece = Piece();
    if (map['id'] != null) {
      piece.id = map['id'];
    }
    if (map['numero'] != null) {
      piece.numero = map['numero'];
    }
    if (map['type'] != null) {
      piece.type = map['type'];
    }
    if (map['url'] != null) {
      piece.url = map['url'];
    }
    if (map['dateExpiration'] != null) {
      piece.dateExpiration = DateTime.parse(map['dateExpiration']);
    }

    return piece;
  }
}
