import 'package:flutter/material.dart';
import 'package:tchakolo/composants/champ.composant.dart';
import 'package:tchakolo/composants/composants.all.dart';

class PasseOublieePage extends StatefulWidget {
  const PasseOublieePage({Key? key}) : super(key: key);

  @override
  _PasseOublieePageState createState() => _PasseOublieePageState();
}

class _PasseOublieePageState extends State<PasseOublieePage> {
  TextEditingController telController =
      new TextEditingController(text: "696543495");
  final _formTelKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            padding: const EdgeInsets.only(
              top: 50,
              left: 32,
              right: 32,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Titre(texte: 'Mot de passe oublié'),
                SousTitre(
                    texte:
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean est mi, sodales sit amet odio ac'),
                formulaireTelephone(_formTelKey),
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
                      'Envoyer le code de confirmation',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Retour'))
              ],
            )),
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
}
