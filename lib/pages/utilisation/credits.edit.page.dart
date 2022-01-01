import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/models/palier.model.dart';
import 'package:tchakolo/pages/utilisation/credits.confirmation.page.dart';

class CreditsEditPage extends StatefulWidget {
  const CreditsEditPage({Key? key}) : super(key: key);

  @override
  _CreditsEditPageState createState() => _CreditsEditPageState();
}

class _CreditsEditPageState extends State<CreditsEditPage> {
  final paliersFirebase = FirebaseFirestore.instance.collection('paliers');
  final demandesFirebase = FirebaseFirestore.instance.collection('demandes');
  final LocalStorage storage = new LocalStorage('tchakolo');
  Color couleur = Colors.grey.shade200;

  List<Color> couleurs = [];

  List<Palier> paliers = [];

  getPaliers() {
    paliersFirebase.get().then((resultats) {
      paliers = [];
      resultats.docs.forEach((resultat) {
        paliers.add(Palier.fromMap(resultat.data()));
      });
      paliers.sort((palier1, palier2) {
        return palier1.montant! - palier2.montant!;
      });
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getPaliers();
  }

  @override
  Widget build(BuildContext context) {
    // getPaliers();
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
          },
          backgroundColor: Color.fromRGBO(18, 15, 62, 1),
          child: const Icon(Icons.add),
        ),
      ),
      body: Container(
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
                margin: EdgeInsets.only(
                  bottom: 0,
                  left: 32,
                  right: 32,
                ),
                width: double.infinity,
                child: Container(
                  child: Text(
                    'Demande de crédit',
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
                  horizontal: 32,
                  vertical: 8,
                ),
                child: Text(
                  "Vous n'avez effectué aucune demande de crédit pour l'instant",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              generatePaliers(paliers),
            ],
          ),
        ),
      ),
    );
  }

  Widget generatePaliers(List<Palier> paliers) {
    List<Widget> widgets = [];
    for (var i = 0; i < paliers.length; i++) {
      var palier = paliers[i];
      couleurs.add(Colors.grey.shade200);
      widgets.add(createPalier(palier, i));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: widgets,
    );
  }

  rendreLeResteGris() {
    for (var i = 0; i < couleurs.length; i++) {
      couleurs[i] = Colors.grey.shade200;
    }
  }

  Widget createPalier(Palier palier, int indexColor) {
    return InkWell(
      onTap: () async {
        GetOptions options;

        print('palier en registré');
        rendreLeResteGris();
        print(couleurs[indexColor]);
        couleurs[indexColor] = Color.fromRGBO(255, 117, 8, 1);
        print(couleur);
        setState(() {
          couleurs[indexColor] = Color.fromRGBO(255, 117, 8, 1);
        });
        storage.setItem('tchaPalierChoisi', palier.toMap());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreditsConfirmation()),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: couleurs[indexColor],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: palier.montant.toString(),
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
            Container(
              width: double.infinity,
              child: Text(
                "Délai de remboursement : " +
                    palier.delai.toString() +
                    " jours",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: couleurs[indexColor] == Color(0xffeeeeee)
                      ? Colors.grey.shade600
                      : Colors.white,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Text(
                'Intérêt : ' + palier.interet.toString() + ' XAF',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: couleurs[indexColor] == Color(0xffeeeeee)
                      ? Colors.grey.shade600
                      : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
