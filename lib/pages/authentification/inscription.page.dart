import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/composants/champ.composant.dart';
import 'package:tchakolo/composants/composants.all.dart';
import 'package:tchakolo/models/utilisateur.model.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({Key? key}) : super(key: key);

  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final LocalStorage storage = new LocalStorage('tchakolo');
  TextEditingController nomController =
      new TextEditingController(text: "Muanza");
  TextEditingController prenomController =
      new TextEditingController(text: "Kangudie");
  TextEditingController dateController = new TextEditingController();
  TextEditingController professionController =
      new TextEditingController(text: "Séducteur");
  TextEditingController paysController =
      new TextEditingController(text: 'Cameroun');
  TextEditingController telController =
      new TextEditingController(text: "696543495");
  TextEditingController leControleur = new TextEditingController();

  final _formNomKey = GlobalKey<FormState>();
  final _formPrenomKey = GlobalKey<FormState>();
  final _formProfessionKey = GlobalKey<FormState>();
  final _formPaysKey = GlobalKey<FormState>();
  final _formTelKey = GlobalKey<FormState>();

  final utilisateursFirebase =
      FirebaseFirestore.instance.collection('utilisateurs');

  DateTime selectedDate = DateTime.now();

  bool isDateChoisie = false;

  bool isShowedDateError = false;

  bool isDejaDesErreurs = false;

  bool isNotMajeur = true;

  bool isUtilisateurExiste = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        // locale: Locale('fr', 'FR'),
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101),
        helpText: "Sélectionner votre date de naissance",
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Color.fromRGBO(18, 15, 62, 1),
                onPrimary: Colors.white,
                surface: Color.fromRGBO(18, 15, 62, 1),
                // onSurface: Colors.black,
              ),
              // dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        });
    if (picked != null && picked != selectedDate) {
      var difference = DateTime.now().difference(selectedDate).inDays;
      print("La difference de date en jours");
      print(difference);
      print(difference > 365 * 21);
      if (difference > 365 * 21) {
        isNotMajeur = false;
      } else {
        isNotMajeur = true;
      }
      isDateChoisie = true;
      isShowedDateError = false;
      selectedDate = picked;
      setState(() {
        var difference = DateTime.now().difference(selectedDate).inDays;
        print("La difference de date en jours");
        print(difference);
        print(difference > 365 * 21);
        if (difference > 365 * 21) {
          isNotMajeur = false;
        } else {
          isNotMajeur = true;
        }
        isDateChoisie = true;
        isShowedDateError = false;
        selectedDate = picked;
      });
    }
  }

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

  connexion() {
    Navigator.pushNamed(
      context,
      '/connexion',
    );
  }

  inscription() {
    Navigator.pushNamed(
      context,
      '/inscription',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                texte: 'Inscription',
              ),
              SousTitre(
                  texte:
                      'Veuillez remplir toutes les informations demandées. Tous les champs de ce formulaire sont obligatoires'),
              formulaireNom(_formNomKey),
              formulairePrenom(_formPrenomKey),
              champDate(),
              formulairePays(_formPaysKey),
              formulaireTelephone(_formTelKey),
              formulaireProfession(_formProfessionKey),
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void save() {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    AlertDialog alertUtilisateurPresent = AlertDialog(
      // title: Text("AlertDialog"),

      content: SizedBox(
        height: 360,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Text(
                          'Utilisateur existe',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff120f3e),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  SousTitre(
                      texte:
                          "Un utilisateur existe déjà dans la base avec ce numéro. S'il s'agit de vous, veuillez vous connecter ! "),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 8,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        inscription();
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Color(0xff9dcd21),
                        minimumSize: Size.fromHeight(
                          50,
                        ), // fromHeight use double.infinity as width and 40 is the height
                      ),
                      child: Text(
                        'S\'inscrire',
                        style: TextStyle(
                          fontSize: 18,
                        ),
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
                        Navigator.pushNamed(
                          context,
                          '/connexion',
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
                        'Se connecter',
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

    var noms = nomController.text;
    var prenoms = prenomController.text;
    var date = dateController.text;
    var profession = professionController.text;
    var pays = paysController.text;
    var tel = telController.text;
    debugPrint('Informations remplies');
    debugPrint(noms);
    debugPrint(prenoms);
    debugPrint(date);
    debugPrint(profession);
    debugPrint(pays);
    debugPrint(tel);

    Utilisateur utilisateur = new Utilisateur(tel);
    utilisateur.noms = noms;
    utilisateur.prenoms = prenoms;
    utilisateur.datenaiss = selectedDate;
    utilisateur.profession = profession;
    utilisateur.pays = pays;
    debugPrint('Utilisateur Map');
    debugPrint(utilisateur.toMap().toString());
    // Map<String, dynamic> data = storage.getItem('key');
    storage.setItem('tchaUtilisateur', utilisateur.toMap());
    utilisateursFirebase.doc(utilisateur.id).get().then((resultat) => {
          if (resultat.exists)
            {
              debugPrint('Utilisateur existe déjà sur Firebase'),
              isUtilisateurExiste = true,
              Navigator.pop(context),
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertUtilisateurPresent;
                },
              ),
            }
          else
            {
              Navigator.pop(context),
              Navigator.pushNamed(
                context,
                '/compte/localisation',
              ),
              /*
              utilisateursFirebase
                  .doc(utilisateur.id)
                  .set(utilisateur.toMap())
                  .then((value) => {
                        debugPrint('Utilisateur enregistré sur Firebase'),
                        
                      })
                  .catchError((onError) {
                debugPrint('ERREUR enregistrement sur Firebase... NDEM');
              })
              */
            }
        });
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

  Form formulaireNom(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: () => {debugPrint('Interaction sur le formaulaire')},
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          Champ(libelle: 'Noms', leControleur: nomController),
        ],
      ),
    );
  }

  Form formulairePrenom(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: () => {debugPrint('Interaction sur le formaulaire')},
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          Champ(libelle: 'Prenoms', leControleur: prenomController),
        ],
      ),
    );
  }

  Form formulairePays(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: () => {debugPrint('Interaction sur le formaulaire')},
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          Champ(
            libelle: 'Pays',
            leControleur: paysController,
            disabled: true,
            bouton: TextButton(
              child: Text(
                '+237',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff9dcd21),
                ),
              ),
              onPressed: () => {},
            ),
          ),
        ],
      ),
    );
  }

  Form formulaireTelephone(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: () => {debugPrint('Interaction sur le formaulaire')},
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          Champ(
            libelle: 'Téléphone',
            leControleur: telController,
            validator: validerTelephone,
            clavier: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Form formulaireProfession(Key idForm) {
    return Form(
      key: idForm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      // onChanged: () => {debugPrint('Interaction sur le formaulaire')},
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          Champ(libelle: 'Profession', leControleur: professionController),
        ],
      ),
    );
  }

  onFormSubmit() {
    var nomValidation = _formNomKey.currentState!.validate();
    var prenomValidation = _formPrenomKey.currentState!.validate();
    var telValidation = _formTelKey.currentState!.validate();
    var professionValidation = _formProfessionKey.currentState!.validate();
    if (nomValidation &&
        prenomValidation &&
        telValidation &&
        professionValidation &&
        isDateChoisie &&
        !isNotMajeur) {
      save();
    } else {
      isDejaDesErreurs = true;
      if (!isDateChoisie) {
        isShowedDateError = true;
        setState(() {
          isShowedDateError = true;
        });
        debugPrint('Aucune date de naissance...');
        return;
      }
      setState(() {});
    }
  }

  Widget champDate() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isShowedDateError
                  ? Colors.red
                  : isDateChoisie && !isNotMajeur
                      ? Color(0xff9dcd21)
                      : Color(0xFFf0f0f0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isDateChoisie
                    ? selectedDate.toIso8601String().split('T')[0]
                    : 'Date de naissance',
                style: TextStyle(
                  color: isDateChoisie ? Colors.black87 : Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  height: 1,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xff9dcd21),
                ),
                onPressed: () {
                  debugPrint('Il veut choisir une date');
                  _selectDate(context);
                },
              )
            ],
          ),
        ),
        isShowedDateError
            ? Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12, left: 20),
                child: Text(
                  'Champ obligatoire',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 4, left: 20),
              ),
        isNotMajeur && isDateChoisie
            ? Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12, left: 20),
                child: Text(
                  'Vous devez être agé de plus de 21 ans',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 4, left: 20),
              )
      ],
    );
  }
}
