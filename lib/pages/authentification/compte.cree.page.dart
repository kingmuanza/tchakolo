import 'package:flutter/material.dart';
import 'package:tchakolo/composants/composants.all.dart';

class CompteCreePage extends StatefulWidget {
  const CompteCreePage({Key? key}) : super(key: key);

  @override
  _CompteCreePageState createState() => _CompteCreePageState();
}

class _CompteCreePageState extends State<CompteCreePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                  texte: 'Votre compte a bien été créé',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Image(
                    image: AssetImage('assets/images/logo.jpeg'),
                    height: 220,
                  ),
                ),
                SousTitre(
                  texte:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis tempor convallis eros ut tempus.',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
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
                      'Me connecter',
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
      ),
    );
  }
}
