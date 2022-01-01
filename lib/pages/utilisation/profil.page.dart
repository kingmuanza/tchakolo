import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/models/piece.model.dart';
import 'package:tchakolo/models/utilisateur.model.dart';
import 'package:tchakolo/pages/utilisation/support.contacter.page.dart';

import '../../main.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  File? image;
  final LocalStorage storage = new LocalStorage('tchakolo');
  final utilisateursFirebase =
      FirebaseFirestore.instance.collection('utilisateurs');

  Utilisateur utilisateur = new Utilisateur('');
  Piece piece = new Piece();
  Text texte = Text(
    "Non identifié",
    style: TextStyle(
      color: Colors.orange,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );

  Text getStatut() {
    String message = 'Non identifié';
    Color c = Colors.green;
    if (utilisateur.statut == 0) {
      message = 'Non identifié';
      c = Colors.red;
    }
    if (utilisateur.statut == 1) {
      message = 'En attente de validation';
      c = Color.fromRGBO(255, 117, 8, 1);
    }
    if (utilisateur.statut == 2) {
      message = 'Compte validé';
      c = Color(0xff9dcd21);
    }
    if (utilisateur.statut == -1) {
      message = 'Demande de validation rejetée';
      c = Colors.red;
    }
    if (utilisateur.statut == -2) {
      message = 'Validation expirée';
      c = Colors.red;
    }
    return Text(
      message,
      style: TextStyle(
        color: c,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhoto();
    getUtilisateur();
    this.texte = this.getStatut();
    setState(() {
      this.texte = this.getStatut();
    });
  }

  @override
  Widget build(BuildContext context) {
    this.texte = this.getStatut();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(
          top: 50,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                bottom: 0,
              ),
              width: double.infinity,
              child: Container(
                child: Text(
                  'Mon profil',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff120f3e),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: texte,
            ),
            // Text(utilisateur.statut.toString()),
            tchaItem('Noms', this.utilisateur.noms),
            tchaItem('Prénoms', this.utilisateur.prenoms),
            tchaItem('Téléphone', '+' + this.utilisateur.tel!),
            this.piece.type != null
                ? tchaItem(
                    this.piece.type == 'CNI'
                        ? "Carte Nationale d'identité"
                        : this.piece.type!,
                    this.piece.numero)
                : Container(),
            this.piece.dateExpiration != null
                ? tchaItem('Date exipration',
                    this.piece.dateExpiration!.toIso8601String().split('T')[0])
                : Container(),
            this.piece.url != null
                ? Container(
                    margin: EdgeInsets.only(
                      top: 16,
                    ),
                    child: Image.network(
                      this.piece.url!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 16,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SupportContacterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Color.fromRGBO(18, 15, 62, 1),
                  minimumSize: Size.fromHeight(
                    50,
                  ), // fromHeight use double.infinity as width and 40 is the height
                ),
                child: Text(
                  'Contacter le support',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Navigator.pop(context);
                  RestartWidget.restartApp(context);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Color.fromRGBO(255, 117, 8, 1),
                  minimumSize: Size.fromHeight(
                    50,
                  ), // fromHeight use double.infinity as width and 40 is the height
                ),
                child: Text(
                  'Déconnexion',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Column tchaItem(String libelle, String? valeur) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            top: 8,
          ),
          width: double.infinity,
          child: Text(
            libelle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Text(
            valeur != null ? valeur : '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  getPhoto() {
    if (storage.getItem('tchaPiece') != null) {
      Map<String, dynamic> pieceString = storage.getItem('tchaPiece');
      Piece piece = Piece.fromMap(pieceString);
      this.piece = piece;
      String? url = piece.url;
      if (url != null) {
        this.image = File(url);
        setState(() {
          this.image = File(url);
        });
      }
    }
  }

  getUtilisateur() {
    if (storage.getItem('tchaUtilisateur') != null) {
      Map<String, dynamic> utilisateurString =
          storage.getItem('tchaUtilisateur');

      print('on check le statut... actu');
      Utilisateur u = Utilisateur.fromMap(utilisateurString);
      utilisateursFirebase.doc(u.id).get().then((value) {
        if (value.exists) {
          this.utilisateur = Utilisateur.fromMap(value.data()!);
          if (this.utilisateur.statut > 0) {
            piece = Piece();
          }
          setState(() {
            this.utilisateur = Utilisateur.fromMap(value.data()!);
            print('on check le statut... après');
          });
        }
      });
    }
  }
}
