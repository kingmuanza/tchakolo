import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/composants/composants.all.dart';
import 'package:http/http.dart' as http;
import 'package:tchakolo/models/utilisateur.model.dart';

class CodeValidation extends StatefulWidget {
  const CodeValidation({Key? key}) : super(key: key);

  @override
  _CodeValidationState createState() => _CodeValidationState();
}

class _CodeValidationState extends State<CodeValidation> {
  final LocalStorage storage = new LocalStorage('tchakolo');
  final utilisateursFirebase =
      FirebaseFirestore.instance.collection('utilisateurs');
  TextEditingController numeroController1 = TextEditingController();
  TextEditingController numeroController2 = TextEditingController();
  TextEditingController numeroController3 = TextEditingController();
  TextEditingController numeroController4 = TextEditingController();
  TextEditingController numeroController5 = TextEditingController();
  TextEditingController numeroController6 = TextEditingController();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();

  dynamic auth = {
    "token_type": "Bearer",
    "access_token": "GWWqSFQY8C3P7lLT2h1AfF7B7f4x",
    "expires_in": 3600
  };

  Utilisateur utilisateur = Utilisateur('');

  late Timer _timer;
  int _start = 600;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String hourLeft =
        h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
        m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
        s.toString().length < 2 ? "0" + s.toString() : s.toString();

    String result = "$hourLeft:$minuteLeft:$secondsLeft";

    return result;
  }

  @override
  void initState() {
    this.startTimer();
    super.initState();
    // this.getSMSAuth();
  }

  @override
  void dispose() {
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
    focusNode5.dispose();
    focusNode6.dispose();
    _timer.cancel();
    super.dispose();
  }

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
            children: <Widget>[
              Titre(texte: 'Code de confirmation'),
              SousTitre(
                texte:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas ac lacus nec tortor ornare consectetur',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 24,
                ),
                child: Row(
                  children: [
                    chiffre(focusNode1, numeroController1, focusNode2),
                    chiffre(focusNode2, numeroController2, focusNode3),
                    chiffre(focusNode3, numeroController3, focusNode4),
                    chiffre(focusNode4, numeroController4, focusNode5),
                    chiffre(focusNode5, numeroController5, focusNode6),
                    chiffre(focusNode6, numeroController6),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  intToTimeLeft(_start),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 8,
                ),
                child: TextButton(
                  onPressed: () {
                    renvoyerLeCode();
                  },
                  child: Text(
                    'Renvoyer le code',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 117, 8, 1),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 32,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    getCode();
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

  getCode() async {
    String code = numeroController1.text +
        numeroController2.text +
        numeroController3.text +
        numeroController4.text +
        numeroController5.text +
        numeroController6.text;

    debugPrint('Code : ' + code);

    var codeEnregistree = storage.getItem('tchaCode');

    if (code == codeEnregistree) {
      debugPrint('_start : ');
      print(_start);
      if (_start != 0) {
        setState(() {
          _timer.cancel();
        });

        Map<String, dynamic> dataUtilisateurLocal =
            storage.getItem('tchaUtilisateur');

        if (dataUtilisateurLocal != null) {
          Utilisateur u = Utilisateur.fromMap(dataUtilisateurLocal);
          debugPrint('utilisateur CODE VALIDATION');
          debugPrint(u.toMap().toString());
          storage.setItem('tchaUtilisateur', u.toMap());
          await utilisateursFirebase.doc(u.id).set(u.toMap());
          Navigator.pushNamed(
            context,
            '/compte/cree',
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('le code n\'est plus valide')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code incorrect')),
      );
    }
  }

  sendSMSviaAPI() async {
    print('auth');
    print(auth);
    Random random = new Random();
    int randomNumber = random.nextInt(899999) + 100000;
    var code = randomNumber.toString();
    storage.setItem('tchaCode', code);
    var numero = this.utilisateur.id;
    Map<String, dynamic> dataUtilisateurLocal =
        storage.getItem('tchaUtilisateur');

    if (dataUtilisateurLocal != null) {
      Utilisateur u = Utilisateur.fromMap(dataUtilisateurLocal);
      debugPrint('utilisateur CODE VALIDATION');
      debugPrint(u.toMap().toString());
      storage.setItem('tchaUtilisateur', u.toMap());
      numero = u.id;
      print('Début envoiSMSEtValidation');
      print(auth['access_token']);
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

  renvoyerLeCode() {
    setState(() {
      _timer.cancel();
    });
    _start = 600;
    this.startTimer();
    sendSMSviaAPI();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Un autre code a été renvoyé')),
    );
  }

  Expanded chiffre(FocusNode focus, TextEditingController controller,
      [FocusNode? suivant]) {
    return Expanded(
      child: TextFormField(
        focusNode: focus,
        controller: controller,
        textAlign: TextAlign.center,
        maxLines: 1,
        maxLength: 1,
        readOnly: false,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
        onChanged: (value) {
          if (value.length > 0) {
            focus.unfocus();
            if (suivant != null) {
              FocusScope.of(context).requestFocus(suivant);
            }
            setState(() {});
          }
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: '-',
          counterText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 10,
          ),
        ),
      ),
    );
  }
}
