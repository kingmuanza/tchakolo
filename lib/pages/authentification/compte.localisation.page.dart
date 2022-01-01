import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/composants/champ.composant.dart';
import 'package:tchakolo/composants/composants.all.dart';
import 'package:tchakolo/models/utilisateur.model.dart';

class CompteLocalisationPage extends StatefulWidget {
  const CompteLocalisationPage({Key? key}) : super(key: key);

  @override
  _CompteLocalisationPageState createState() => _CompteLocalisationPageState();
}

class _CompteLocalisationPageState extends State<CompteLocalisationPage> {
  final LocalStorage storage = new LocalStorage('tchakolo');
  TextEditingController villeController =
      new TextEditingController(text: 'Yaoundé');
  TextEditingController quartierController =
      new TextEditingController(text: 'Ngousso');
  TextEditingController rueController =
      new TextEditingController(text: 'Derrière la Chapelle');

  final _formVilleKey = GlobalKey<FormState>();
  final _formQuartierKey = GlobalKey<FormState>();
  final _formRueKey = GlobalKey<FormState>();

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

  bool isDejaDesErreurs = false;

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
                Titre(texte: 'Où êtes-vous ?'),
                SousTitre(
                  texte:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas ac lacus nec tortor ornare consectetur',
                ),
                formulaireVille(_formVilleKey),
                formulaireQuartier(_formQuartierKey),
                formulaireRue(_formRueKey),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
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

  Form formulaireRue(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Champ(libelle: 'Rue', leControleur: rueController),
        ],
      ),
    );
  }

  Form formulaireVille(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Champ(libelle: 'Ville', leControleur: villeController),
        ],
      ),
    );
  }

  Form formulaireQuartier(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Champ(libelle: 'Quartier', leControleur: quartierController),
        ],
      ),
    );
  }

  Future getInfo() {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    var ville = villeController.text;
    var quartier = quartierController.text;
    var rue = rueController.text;
    debugPrint('Informations remplies');
    debugPrint(ville);
    debugPrint(quartier);
    debugPrint(rue);

    Map<String, dynamic> dataUtilisateurLocal =
        storage.getItem('tchaUtilisateur');
    debugPrint(dataUtilisateurLocal.toString());
    if (dataUtilisateurLocal != null) {
      Utilisateur utilisateur = Utilisateur.fromMap(dataUtilisateurLocal);
      utilisateur.quartier = quartier;
      utilisateur.ville = ville;
      utilisateur.rue = rue;
      debugPrint('utilisateur récupéré localement');
      debugPrint(utilisateur.toMap().toString());
      storage.setItem('tchaUtilisateur', utilisateur.toMap());
    }
    return Future.delayed(
        Duration(
          seconds: 2,
        ), () {
      Navigator.pop(context);
      return true;
    });
  }

  onFormSubmit() {
    var villeValidation = _formVilleKey.currentState!.validate();
    var quartierValidation = _formQuartierKey.currentState!.validate();
    var rueValidation = _formRueKey.currentState!.validate();

    if (villeValidation && quartierValidation && rueValidation) {
      getInfo().then((value) => {
            Navigator.pushNamed(
              context,
              '/compte/creation',
            )
          });
    }
  }
}
