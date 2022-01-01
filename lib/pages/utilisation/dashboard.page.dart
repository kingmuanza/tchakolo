import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/models/demande.credit.model.dart';
import 'package:tchakolo/models/utilisateur.model.dart';
import 'package:tchakolo/pages/utilisation/identification.info.page.dart';

import '../../main.dart';
import 'credits.confirmation.page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isPieceEnvoyee = false;
  final LocalStorage storage = new LocalStorage('tchakolo');

  final demandesFirebase = FirebaseFirestore.instance.collection('demandes');
  final utilisateursFirebase =
      FirebaseFirestore.instance.collection('utilisateurs');
  final piecesFirebase = FirebaseFirestore.instance.collection('pieces');
  List<Color> couleurs = [];
  List<DemandeCredit> demandes = [];
  Utilisateur utilisateur = Utilisateur('', 2);

  getDemandesCredits() async {
    print("getDemandesCredits");
    Map<String, dynamic> utilisateurString = storage.getItem('tchaUtilisateur');
    Utilisateur utilisateur = Utilisateur.fromMap(utilisateurString);
    List<DemandeCredit> all = [];
    QuerySnapshot datas = await demandesFirebase.get();
    List<QueryDocumentSnapshot> docs = datas.docs;
    docs.forEach((doc) {
      DemandeCredit d = DemandeCredit.fromMap(doc.data());
      if (d.idutilisateur == utilisateur.id) {
        all.add(DemandeCredit.fromMap(doc.data()));
      }
    });
    all.sort((a, b) {
      return b.dateDemande!.millisecondsSinceEpoch -
          a.dateDemande!.millisecondsSinceEpoch;
    });
    demandes = all;
    setState(() {
      demandes = all;
      print("demandes.length");
      print(demandes.length);
    });
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
          if (this.utilisateur.statut == 2) {
            piecesFirebase.doc(this.utilisateur.id).get().then((v) {
              storage.setItem("tchaPiece", v.data());
              // this.utilisateur = Utilisateur.fromMap(value.data()!);
              print('on check le statut... après 2');
              print(this.utilisateur.toMap());
              setState(() {
                this.utilisateur = Utilisateur.fromMap(value.data()!);
                print(this.utilisateur.toMap());
              });
            });
          } else {
            if (this.utilisateur.statut < 1) {
              storage.deleteItem("tchaPiece");
            }
            // this.utilisateur = Utilisateur.fromMap(value.data()!);
            print('on check le statut... après autre');
            setState(() {
              this.utilisateur = Utilisateur.fromMap(value.data()!);
              print('on check le statut... après');
              print(value.data()!);
            });
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.getDemandesCredits();
    getUtilisateur();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(
            top: 50,
            left: 0,
            right: 0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.only(
                    bottom: 0,
                    left: 24,
                    right: 24,
                  ),
                  child: Text(
                    'Accueil',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff120f3e),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              contenu(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contenu() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        getStatut(),
        libelle(),
        soldeTotal(),
        ligneSeparation('01/12/2021'),
        contentTab1(),
      ],
    );
  }

  Container libelle() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: 12,
        left: 24,
        right: 24,
      ),
      child: Text(
        "Bénéfices générés dans l'application",
        style: TextStyle(
          fontSize: 17,
          // fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Container soldeTotal() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: 8,
        left: 24,
        right: 24,
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 0.toString(),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 117, 8, 1),
              ),
            ),
            TextSpan(
              text: ' XAF',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 32,
                color: Color.fromRGBO(18, 15, 62, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container ligneSeparation(String texte) {
    return Container(
      margin: EdgeInsets.only(
        top: 16,
        left: 24,
        right: 24,
      ),
      padding: EdgeInsets.only(
        bottom: 6,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black54,
            width: 1.0,
          ),
        ),
      ),
      child: Text(
        texte,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Container getStatut() {
    if (utilisateur.statut == 0) {
      return pieceNonEnvoyee(context);
    }
    if (utilisateur.statut == 1) {
      return pieceEnAttente(context);
    }
    if (utilisateur.statut == 2) {
      return Container();
    }
    return Container();
  }

  Container pieceNonEnvoyee(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 16,
      ),
      padding: EdgeInsets.only(
        left: 32,
        right: 28,
        top: 16,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 117, 8, 1),
      ),
      child: Column(
        children: [
          Text(
            "Votre compte n'a pas encore été validé. Veuillez enregistrer votre pièce d'identité pour pouvoir effectuer des opérations dans l'application",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.35,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 24,
              bottom: 8,
            ),
            margin: EdgeInsets.only(right: 100),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IdentificationInfoPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Color.fromRGBO(18, 15, 62, 1),
                  padding: EdgeInsets.only(
                    top: 12,
                    bottom: 12,
                    left: 20,
                    right: 20,
                  ) // fromHeight use double.infinity as width and 40 is the height
                  ),
              child: Text(
                'Continuer',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container pieceEnAttente(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 16,
      ),
      padding: EdgeInsets.only(
        left: 32,
        right: 28,
        top: 16,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: Color.fromRGBO(18, 15, 62, 1),
      ),
      child: Column(
        children: [
          Text(
            "Votre compte est en cours de validation. Veuillez patienter avant d'effectuer des opérations sur la plateforme. Merci de votre confiance",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.35,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 0,
            ),
            margin: EdgeInsets.only(right: 100),
          ),
        ],
      ),
    );
  }

  Widget contentTab1() {
    if (demandes.length == 0) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 24,
        ),
        child: Text(
          "Vous n'avez effectué aucune demande de crédit pour l'instant",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 16),
        child: generateDemandeCredits(demandes),
      );
    }
  }

  Widget contentTab2() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 24,
      ),
      child: Text(
        "Vous n'avez effectué aucun prêt pour l'instant",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget generateDemandeCredits(List<DemandeCredit> demandes) {
    print("generateDemandeCredits");
    print(demandes.length);
    List<Widget> widgets = [];
    for (var i = 0; i < demandes.length; i++) {
      var demandeCredit = demandes[i];
      couleurs.add(Color.fromRGBO(255, 117, 8, 1));
      widgets.add(createDemandeCredit(demandeCredit, i));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgets,
    );
  }

  rendreLeResteGris() {
    for (var i = 0; i < couleurs.length; i++) {
      couleurs[i] = Color.fromRGBO(255, 117, 8, 1);
    }
  }

  Widget createDemandeCredit(DemandeCredit demandeCredit, int indexColor) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 117, 8, 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      'Demande de crédit',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      '01/01/2012',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: demandeCredit.montant.toString(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: couleurs[indexColor] == Color(0xffeeeeee)
                            ? Colors.black87
                            : Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: ' XAF',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 28,
                        color: couleurs[indexColor] == Color(0xffeeeeee)
                            ? Colors.black87
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
