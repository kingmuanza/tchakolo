import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/composants/champ.composant.dart';
import 'package:tchakolo/composants/composants.all.dart';
import 'package:tchakolo/models/utilisateur.model.dart';

class ConnexionPage extends StatefulWidget {
  const ConnexionPage({Key? key}) : super(key: key);

  @override
  _ConnexionPageState createState() => _ConnexionPageState();
}

class _ConnexionPageState extends State<ConnexionPage> {
  final LocalStorage storage = new LocalStorage('tchakolo');
  TextEditingController telController =
      TextEditingController(text: '696543495');
  TextEditingController passeController =
      TextEditingController(text: '@BCdef123');
  final _formKey = GlobalKey<FormState>();
  final utilisateursFirebase =
      FirebaseFirestore.instance.collection('utilisateurs');

  var isDejaDesErreurs = false;
  var isPasseOublie = false;

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                top: 50,
                left: 32,
                right: 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Titre(
                    texte: 'Connexion',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Image(
                      image: AssetImage('assets/images/logo.jpeg'),
                      height: 100,
                    ),
                  ),
                  SousTitre(
                    texte:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis tempor convallis eros ut tempus.',
                  ),
                  formulaire(_formKey),
                ],
              ),
            ),
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  String? validerTelephone(value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    } else {
      if (value.toString().split(' ').join('').split('-').join('').length !=
          9) {
        return 'Le numéro de téléphone doit comporter 9 chiffres';
      }
      if (value.toString()[0] != '6') {
        return 'Le numéro de téléphone doit commencer par un 6';
      }
    }
    return null;
  }

  String? validationLongueur(dynamic value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    } else {
      if (5 > value.toString().length) {
        return 'Le mot de passe doit comporter plus de 5 caractères';
      }
    }
    return null;
  }

  Form formulaire(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: isDejaDesErreurs
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: Column(
        children: [
          Champ(
            libelle: 'Téléphone',
            leControleur: telController,
            validator: validerTelephone,
          ),
          ChampPassword(
              libelle: 'Mot de passe',
              leControleur: passeController,
              validator: validationLongueur),
          isPasseOublie
              ? TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/passe/oubliee',
                    );
                  },
                  style: TextButton.styleFrom(
                    // backgroundColor: Colors.red,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    alignment: Alignment.centerLeft,
                    elevation: 0,
                  ),
                  clipBehavior: Clip.none,
                  child: Text(
                    "Mot de passe oublié ?",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      // decoration: TextDecoration.underline,
                      //color: Color.fromRGBO(255, 117, 8, 1),
                      // color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 8,
            ),
            child: ElevatedButton(
              onPressed: () {
                onSubmitForm();
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Color.fromRGBO(18, 15, 62, 1),
                minimumSize: Size.fromHeight(
                  50,
                ), // fromHeight use double.infinity as width and 40 is the height
              ),
              child: Text(
                'Me connecter',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 8, right: 8),
            child: Text("Vous ne possédez pas encore de compte ?"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/inscription',
              );
            },
            child: Text(
              "Inscrivez-vous ici",
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Color(0xff9dcd21),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  onSubmitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      var tel = telController.text;
      var passe = passeController.text;
      connexion(tel.split(' ').join('').split('-').join(''), passe)
          .then((value) => {
                // Navigator.pop(context),
                Navigator.pushNamed(
                  context,
                  '/tabs',
                )
              });
    } else {
      isDejaDesErreurs = true;
      setState(() {});
    }
  }

  connexion(String id, String passe) async {
    print('Connexion');
    print(id);
    print('237' + id);
    var resultat = await utilisateursFirebase.doc('237' + id).get();
    print('fin firebase');
    print(resultat);
    print(resultat.data());
    var u = resultat.data();
    if (u != null) {
      print('utilisateur troubvé');
      Utilisateur utilisateur = Utilisateur.fromMap(u);
      if (utilisateur.passe != null) {
        var passwordHachee = utilisateur.passe;
        print(passwordHachee);
        print(passe);
        var result =
            await FlutterBcrypt.verify(password: passe, hash: passwordHachee!);
        print("result: " + (result ? "ok" : "nok"));
        if (!result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mot de passe incorrect')),
          );
          isPasseOublie = true;
          setState(() {
            isPasseOublie = true;
          });
          throw "Mot de passe incorrect";
        } else {
          storage.setItem('tchaUtilisateur', u);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun utilisateur trouvé')),
      );
      throw "Aucun utilisateur trouvé";
    }
  }
}
