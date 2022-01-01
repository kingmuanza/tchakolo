import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/models/demande.credit.model.dart';
import 'package:tchakolo/models/palier.model.dart';
import 'package:tchakolo/models/utilisateur.model.dart';
import 'package:tchakolo/pages/utilisation/credits.page.dart';

class CreditsConfirmation extends StatefulWidget {
  const CreditsConfirmation({Key? key}) : super(key: key);

  @override
  _CreditsConfirmationState createState() => _CreditsConfirmationState();
}

class _CreditsConfirmationState extends State<CreditsConfirmation> {
  final LocalStorage storage = new LocalStorage('tchakolo');
  final demandesFirebase = FirebaseFirestore.instance.collection('demandes');
  Palier palier = Palier();

  bool checkedValue = false;

  @override
  Widget build(BuildContext context) {
    var palierString = storage.getItem('tchaPalierChoisi');
    if (palierString != null) {
      palier = Palier.fromMap(palierString);
    }
    return Container(
      padding: const EdgeInsets.only(
        top: 50,
        left: 32,
        right: 32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Container(
              child: Text(
                'Confirmer la demande de crédit',
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
            padding: EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Vous avez demandé un crédit de " +
                        palier.montant!.toString() +
                        " XAF à rembourser avec intérêt de ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: palier.interet!.toString() + " XAF ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: "dans un délai de ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: palier.delai!.toString() + " jours",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CheckboxListTile(
            title: Text(
              "J'accepte les conditions d'utilisation",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            contentPadding: EdgeInsets.all(0),
            value: checkedValue,
            activeColor: Color(0xff9dcd21),
            onChanged: (newValue) {
              setState(() {
                checkedValue = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
          Container(
            //color: Colors.red,
            width: double.infinity,
            padding: EdgeInsets.only(left: 55),
            child: TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/conditions',
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.topLeft,
              ),
              child: Text(
                "Lire les conditions d'utilisation",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  // color: Color.fromRGBO(18, 15, 62, 1),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      demanderCredit();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Color.fromRGBO(18, 15, 62, 1),
                      minimumSize: Size.fromHeight(
                        50,
                      ), // fromHeight use double.infinity as width and 40 is the height
                    ),
                    child: Text(
                      'Je confirme',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Annuler',
                      style: TextStyle(
                        color: Color.fromRGBO(18, 15, 62, 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  demanderCredit() async {
    Map<String, dynamic> uString = storage.getItem('tchaUtilisateur');
    Utilisateur utilisateur = Utilisateur.fromMap(uString);
    DemandeCredit demandeCredit = DemandeCredit(utilisateur);
    demandeCredit.montant = palier.montant;
    demandeCredit.interet = palier.interet;
    demandeCredit.delai = palier.delai;
    if (checkedValue) {
      print(demandeCredit.toMap());
      await demandesFirebase.doc(demandeCredit.id).set(demandeCredit.toMap());
      print("Demande enregistrée");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreditsPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Veuillez accepter les conditions d'utilisation",
          ),
        ),
      );
    }
  }
}
