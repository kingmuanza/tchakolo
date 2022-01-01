import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:tchakolo/composants/champ.composant.dart';
import 'package:tchakolo/composants/composants.all.dart';
import 'package:tchakolo/models/piece.model.dart';
import 'package:tchakolo/models/utilisateur.model.dart';
import 'package:tchakolo/pages/utilisation/upload.photo.page.dart';

class IdentificationInfoPage extends StatefulWidget {
  const IdentificationInfoPage({Key? key}) : super(key: key);

  @override
  _IdentificationInfoPageState createState() => _IdentificationInfoPageState();
}

class _IdentificationInfoPageState extends State<IdentificationInfoPage> {
  final LocalStorage storage = new LocalStorage('tchakolo');
  TextEditingController numeroController =
      new TextEditingController(text: "0123456789");
  final _formCNIKey = GlobalKey<FormState>();
  final _formNumeroKey = GlobalKey<FormState>();
  String dropdownValue = 'CNI';
  bool isDateChoisie = false;

  bool isShowedDateError = false;

  bool isDejaDesErreurs = false;

  bool isNotValide = true;

  DateTime selectedDate = DateTime.now();

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
        isNotValide = false;
      } else {
        isNotValide = true;
      }
      isDateChoisie = true;
      isShowedDateError = false;
      selectedDate = picked;
      setState(() {
        var difference = DateTime.now().difference(selectedDate).inDays;
        print("La difference de date en jours");
        print(difference);
        print(difference < 0);
        if (difference < 0) {
          isNotValide = false;
        } else {
          isNotValide = true;
        }
        isDateChoisie = true;
        isShowedDateError = false;
        selectedDate = picked;
      });
    }
  }

  List<DropdownMenuItem<String>> items = <String>['CNI', 'Passeport']
      .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: value == 'CNI' ? Text("Carte Nationale d'identité") : Text(value),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          padding: const EdgeInsets.only(
            top: 50,
            left: 0,
            right: 0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                  bottom: 8,
                  left: 32,
                  right: 32,
                ),
                width: double.infinity,
                child: Container(
                  child: Text(
                    "M'identifier",
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
                padding: EdgeInsets.only(left: 32),
                margin: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Quelle pièce d'identification possédez-vous ?",
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 7),
                      child: selectPiece(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Form(
                        key: _formNumeroKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Champ(
                          libelle: "Numéro de la pièce",
                          leControleur: numeroController,
                          validator: auMoins6,
                        ),
                      ),
                    ),
                    champDate(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
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
                                "M'identifier",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
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
                  ],
                ),
              ),
            ],
          )),
    );
  }

  String? auMoins6(value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    } else {
      if (value.toString().length < 6) {
        return 'Numéro de pièce invalide';
      }
    }
    return null;
  }

  void getValue(String? newValue) {
    setState(() {
      dropdownValue = newValue!;
      print('Pièce dientité');
      print(dropdownValue);
    });
  }

  ChampSelect selectPiece() {
    return ChampSelect(
      dropdownValue: 'CNI',
      libelle: "Votre pièce d'identification",
      items: items,
      onChanged: getValue,
    );
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
                  : isDateChoisie && !isNotValide
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
                    : "Date d'expiration",
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
        isNotValide && isDateChoisie
            ? Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12, left: 20),
                child: Text(
                  "La pièce doit être en cours de validité",
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

  onFormSubmit() {
    if (_formNumeroKey.currentState != null) {
      print("_formNumeroKey.currentState!.validate()");
      print(_formNumeroKey.currentState!.validate());
      print("dropdownValue != null");
      print(dropdownValue);
      print("isDateChoisie");
      print(isDateChoisie);
      print("isNotValide");
      print(isNotValide);
      if (_formNumeroKey.currentState!.validate() &&
          dropdownValue != null &&
          isDateChoisie &&
          !isNotValide) {
        print("Le formulaire est bon");
        Map<String, dynamic> utilisateurPresent =
            storage.getItem('tchaUtilisateur');
        Utilisateur utilisateur = Utilisateur.fromMap(utilisateurPresent);
        Piece piece = new Piece(utilisateur);
        piece.type = dropdownValue;
        piece.numero = numeroController.text;
        piece.dateExpiration = selectedDate;
        print("Piece");
        print(piece.toMap());
        storage.setItem('tchaPiece', piece.toMap());
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UploadPhotoPage()),
        );
      } else {
        if (!isDateChoisie) {
          isShowedDateError = true;
          setState(() {
            isShowedDateError = true;
          });
          debugPrint('Aucune date de validité...');
          return;
        }
      }
    }
  }
}
