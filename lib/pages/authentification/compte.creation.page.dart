import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/composants/champ.composant.dart';
import 'package:tchakolo/composants/composants.all.dart';
import 'package:tchakolo/models/utilisateur.model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CompteCreationPage extends StatefulWidget {
  const CompteCreationPage({Key? key}) : super(key: key);

  @override
  _CompteCreationPageState createState() => _CompteCreationPageState();
}

class _CompteCreationPageState extends State<CompteCreationPage> {
  final LocalStorage storage = new LocalStorage('tchakolo');
  final utilisateursFirebase =
      FirebaseFirestore.instance.collection('utilisateurs');
  TextEditingController passeController =
      new TextEditingController(text: '@BCdef123');
  TextEditingController passeConfirmationController =
      new TextEditingController(text: '@BCdef123');

  final _formPasseKey = GlobalKey<FormState>();
  final _formConfirmationKey = GlobalKey<FormState>();

  bool isPassesIdentiques = true;
  bool checkedValue = true;

  AlertDialog alert = AlertDialog(
    // title: Text("AlertDialog"),
    content: SizedBox(
      height: 120,
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
                    'Veuillez patienter...',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                CircularProgressIndicator(
                  color: Color(0xff120f3e),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Utilisateur utilisateur = Utilisateur('');

  AlertDialog afficherMessage() {
    return AlertDialog(
      // title: Text("AlertDialog"),
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
                      'Vous y êtes presque',
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
                      'Message de confirmation indiquant que le formulaire a bien été rempli, qu’un code a été envoyé par SMS à son numéro et que ce code doit être rempli dans un délai imparti',
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
                        envoiSMSEtValidation();
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

  bool isDejaDesErreurs = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 32,
              right: 32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Titre(texte: 'Protégez-vous par un mot de passe'),
                SousTitre(
                  texte:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas ac lacus nec tortor ornare consectetur',
                ),
                formulairePasse(_formPasseKey),
                formulaireConfirmation(_formConfirmationKey),
                !isPassesIdentiques
                    ? Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 12, left: 20),
                        child: Text(
                          'Les mots de passe ne sont pas identiques',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Container(),
                CheckboxListTile(
                  title: Text("J'accepte les conditions d'utilisation"),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 16,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      onFormSubmit();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Color.fromRGBO(18, 15, 62, 1),
                      minimumSize: Size.fromHeight(
                        50,
                      ), // fromHeight use double.infinity as width and 40 is the height
                    ),
                    child: Text(
                      'Suivant',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  bool hasNumber(String s) {
    bool b = false;
    for (int i = 0; i < 10; i++) {
      if (s.indexOf(i.toString()) != -1) {
        b = true;
      }
    }
    return b;
  }

  String? validationLongueur(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    } else {
      if (5 > value.toString().length) {
        return 'Doit comporter plus de 5 caractères';
      }
      if (!hasNumber(value.toString())) {
        return 'Doit contenir au moins un chiffre';
      }
      if (!this.validateStructure(value)) {
        return 'Doit contenir une majuscule et un caractère spéciale';
      }
    }
    return null;
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Form formulairePasse(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          ChampPassword(
            libelle: 'Mot de passe',
            leControleur: passeController,
            validator: validationLongueur,
          ),
        ],
      ),
    );
  }

  Form formulaireConfirmation(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          ChampPassword(
            libelle: 'Confirmer le mot de passe',
            leControleur: passeConfirmationController,
            validator: validationLongueur,
          ),
        ],
      ),
    );
  }

  Future getInfo() async {
    // show the dialog

    var passe = passeController.text;
    var confirmation = passeConfirmationController.text;
    debugPrint('Informations remplies');
    debugPrint(passe);
    debugPrint(confirmation);

    Map<String, dynamic> dataUtilisateurLocal =
        storage.getItem('tchaUtilisateur');
    debugPrint(dataUtilisateurLocal.toString());
    if (dataUtilisateurLocal != null) {
      if (passe == confirmation) {
        isPassesIdentiques = true;
        setState(() {});
        debugPrint('Mots de passe Identiques');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return alert;
          },
        );
        Utilisateur utilisateur = Utilisateur.fromMap(dataUtilisateurLocal);

        var salt10 = await FlutterBcrypt.saltWithRounds(rounds: 4);
        debugPrint("salt10 " + salt10);
        var nouveauPasse = await FlutterBcrypt.hashPw(
          password: passe,
          salt: salt10,
        );
        print("nouveauPasse : " + nouveauPasse);
        utilisateur.passe = nouveauPasse;
        this.utilisateur = utilisateur;
        debugPrint('utilisateur COMPTE CREATION');
        debugPrint(utilisateur.toMap().toString());
        storage.setItem('tchaUtilisateur', utilisateur.toMap());

        // await utilisateursFirebase.doc(utilisateur.id).set(utilisateur.toMap());

        return Future.delayed(
            Duration(
              seconds: 1,
            ), () {
          Navigator.pop(context);
          return true;
        });
      } else {
        isPassesIdentiques = false;
        setState(() {});
        debugPrint('les Mots de passe ne sont pas Identiques');
      }
    }

    return Future.delayed(
        Duration(
          seconds: 1,
        ), () {
      // Navigator.pop(context);
      return true;
    });
  }

  onFormSubmit() {
    if (_formPasseKey.currentState!.validate() && checkedValue) {
      getInfo().then((value) => {
            if (isPassesIdentiques)
              {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return afficherMessage();
                  },
                )
              }
          });
    } else {
      isDejaDesErreurs = true;
      if (!checkedValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Veuillez accepter les conditions d'utilisation")),
        );
      }
      setState(() {});
    }
  }

  envoiSMSEtValidation() {
    print('envoiSMSEtValidation');
    Navigator.pop(context);
    sendSMSviaAPI().then(() {});
  }

  sendSMSviaAPI() async {
    Random random = new Random();
    int randomNumber = random.nextInt(899999) + 100000;
    var code = randomNumber.toString();
    storage.setItem('tchaCode', code);
    var numero = this.utilisateur.id;
    print('Début envoiSMSEtValidation');
    var url = Uri.https('moneytrans.waveslights.com',
        '/administration/sendsms2.php', {'numero': numero, 'code': code});

    try {
      var response = await http.get(url);
      print('FIN de l envoiSMSEtValidation');
      if (response.statusCode == 200) {
        var jsonResponse = response.body;

        print(jsonResponse);
        Navigator.pushNamed(
          context,
          '/code/validation',
        );
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // print(e);
    }
  }
}
