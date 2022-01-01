import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/models/demande.credit.model.dart';
import 'package:tchakolo/models/utilisateur.model.dart';
import 'package:tchakolo/pages/utilisation/credits.confirmation.page.dart';
import 'package:tchakolo/pages/utilisation/credits.edit.page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CreditsPage extends StatefulWidget {
  const CreditsPage({Key? key}) : super(key: key);

  @override
  _CreditsPageState createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  int _selectedIndex = 0;
  int tabIndex = 0;

  List<Color> couleurs = [];
  List<Widget> list = [
    Tab(icon: Icon(Icons.card_travel)),
    Tab(icon: Icon(Icons.add_shopping_cart)),
  ];
  final LocalStorage storage = new LocalStorage('tchakolo');
  final demandesFirebase = FirebaseFirestore.instance.collection('demandes');
  List<DemandeCredit> demandes = [];

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

  AlertDialog afficherMessage() {
    return AlertDialog(
      content: Container(
        height: 350,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Une demande à la fois',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff120f3e),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      "Vous ne pouvez effectuer plusiseurs demandes. Veuillez annuler la précédente ou rembourser le montant emprunté",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Color(0xff9dcd21),
                        minimumSize: Size.fromHeight(
                          50,
                        ), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      child: Text(
                        'J\'ai compris',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getDemandesCredits();
  }

  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await this.getDemandesCredits();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await this.getDemandesCredits();
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    items.add((items.length + 1).toString());
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    // this.getDemandesCredits();
    print("tabIndex");
    print(tabIndex);
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          onPressed: () async {
            print('Vous tentez de faire une demande de crédit');
            bool peutFaire = true;
            QuerySnapshot demandesResultats = await demandesFirebase
                .where("idutilisateur", isEqualTo: '237696543495')
                .get();
            demandesResultats.docs.forEach((doc) {
              print('doc.data()');
              print(doc.data());
              DemandeCredit d = DemandeCredit.fromMap(doc.data());
              if (d.dateRecue == null) {
                peutFaire = false;
              }
            });

            if (peutFaire) {
              print('Vous pouvez faire une demande de crédit');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreditsEditPage()),
              );
            } else {
              print('Vous ne pouvez pas faire une demande de crédit');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return afficherMessage();
                },
              );
            }
          },
          backgroundColor: Color.fromRGBO(18, 15, 62, 1),
          child: const Icon(Icons.add),
        ),
      ),
      body: SingleChildScrollView(
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
                  bottom: 8,
                  left: 24,
                  right: 24,
                ),
                width: double.infinity,
                child: Container(
                  child: Text(
                    'Crédits',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff120f3e),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              DefaultTabController(
                length: 2,
                initialIndex: tabIndex,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Color(0xff120f3e),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Color(0xff120f3e),
                      onTap: (index) {
                        tabIndex = index;
                        setState(() {
                          tabIndex = index;
                        });
                      },
                      tabs: [
                        Tab(text: 'Demandes'),
                        Tab(text: 'Prêts'),
                      ],
                    ),
                  ],
                ),
              ),
              tabIndex == 0 ? contentTab1() : contentTab2(),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget contentTab1() {
    if (demandes.length == 0) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 32,
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
      couleurs.add(Colors.grey.shade200);
      widgets.add(createDemandeCredit(demandeCredit, i));
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

  Widget createDemandeCredit(DemandeCredit demandeCredit, int indexColor) {
    return InkWell(
      onTap: () {
        print('demandeCredit en registré');
        rendreLeResteGris();
        print(couleurs[indexColor]);
        couleurs[indexColor] = Color.fromRGBO(255, 117, 8, 1);
        setState(() {
          couleurs[indexColor] = Color.fromRGBO(255, 117, 8, 1);
        });
        storage.setItem('tchaDemandeCreditChoisi', demandeCredit.toMap());
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
          horizontal: 24,
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
            demandeCredit.dateRecue != null
                ? Container(
                    width: double.infinity,
                    child: Text(
                      "Délai de remboursement : " +
                          demandeCredit.delai.toString() +
                          " jours",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: couleurs[indexColor] == Color(0xffeeeeee)
                            ? Colors.grey.shade600
                            : Colors.white,
                      ),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        "En attente d'un prêteur. Veuillez patienter, vous serez notifié"),
                  ),
            demandeCredit.dateRecue != null
                ? Container(
                    width: double.infinity,
                    child: Text(
                      'Intérêt : ' + demandeCredit.interet.toString() + ' XAF',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: couleurs[indexColor] == Color(0xffeeeeee)
                            ? Colors.grey.shade600
                            : Colors.white,
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(right: 100),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/inscription',
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
                        'Annuler',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
