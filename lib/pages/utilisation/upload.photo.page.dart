import 'dart:io';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tchakolo/models/piece.model.dart';
import 'package:tchakolo/models/utilisateur.model.dart';
import 'package:tchakolo/pages/utilisation/upload.termine.page.dart';

class UploadPhotoPage extends StatefulWidget {
  const UploadPhotoPage({Key? key}) : super(key: key);

  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  List<firebase_storage.UploadTask> _uploadTasks = [];
  firebase_storage.Reference? ref;

  /// The user selects a file, and the task is added to the list.
  Future<firebase_storage.UploadTask?> uploadFile(
      File? file, String nom) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));

      return null;
    }

    firebase_storage.UploadTask uploadTask;

    // Create a Reference to the file
    this.ref =
        firebase_storage.FirebaseStorage.instance.ref().child('pp').child(nom);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    uploadTask = ref!.putFile(io.File(file.path), metadata);

    return Future.value(uploadTask);
  }

  final piecesFirebase = FirebaseFirestore.instance.collection('pieces');
  final utilisateursFirebase =
      FirebaseFirestore.instance.collection('utilisateurs');
  final LocalStorage storage = new LocalStorage('tchakolo');
  TextEditingController numeroController = new TextEditingController(text: "");
  final ImagePicker _picker = ImagePicker();
  final _formCNIKey = GlobalKey<FormState>();
  final _formNumeroKey = GlobalKey<FormState>();
  String dropdownValue = 'CNI';
  bool isDateChoisie = false;

  bool isShowedDateError = false;
  bool isEnCoursEnvoi = false;

  bool isDejaDesErreurs = false;

  bool isNotValide = true;

  DateTime selectedDate = DateTime.now();

  File? image;
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
    return SingleChildScrollView(
      child: isEnCoursEnvoi
          ? Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Container(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          "la photo est en cours d'envoi",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
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
              ),
            )
          : contentPage(context),
    );
  }

  Container contentPage(BuildContext context) {
    return Container(
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
                  "Uploader la CNI",
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
              padding: EdgeInsets.only(left: 32, right: 32),
              margin: EdgeInsets.only(bottom: 16),
              child: Text(
                "Quisque nec volutpat dui, eget porttitor justo. Vivamus euismod eu ipsum a pellentesque.",
                textAlign: TextAlign.left,
              ),
            ),
            this.image == null
                ? Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 8,
                    ),
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: IconButton(
                        onPressed: () {
                          ouvrirMenu(context);
                        },
                        icon: Icon(
                          Icons.upload_file,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      ouvrirMenu(context);
                    },
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 8,
                      ),
                      child: Image.file(
                        this.image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 8,
              ),
              child: Row(
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
                          "Envoyer",
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
            ),
          ],
        ));
  }

  ouvrirMenu(BuildContext ctx) {
    showAdaptiveActionSheet(
      context: ctx,
      title: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: const Text(
          'Importer une image',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      actions: <BottomSheetAction>[
        BottomSheetAction(
          title: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Color.fromRGBO(18, 15, 62, 1),
              minimumSize: Size.fromHeight(
                50,
              ), // fromHeight use double.infinity as width and 40 is the height
            ),
            onPressed: () async {
              Navigator.pop(context);
              XFile? imageSelected =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (imageSelected != null) {
                this.image = File(imageSelected.path);
                setState(() {
                  this.image = File(imageSelected.path);
                });
              }
            },
            child: const Text(
              'Depuis la Galerie',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          onPressed: () async {},
        ),
        BottomSheetAction(
          title: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Color.fromRGBO(18, 15, 62, 1),
              minimumSize: Size.fromHeight(
                50,
              ), // fromHeight use double.infinity as width and 40 is the height
            ),
            onPressed: () async {
              Navigator.pop(context);
              XFile? imageSelected =
                  await _picker.pickImage(source: ImageSource.camera);
              if (imageSelected != null) {
                this.image = File(imageSelected.path);
                setState(() {
                  this.image = File(imageSelected.path);
                });
              }
            },
            child: const Text(
              "Depuis l'Appareil Photo",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          onPressed: () async {},
        ),
      ],
      cancelAction: CancelAction(
        title: const Text(
          'Fermer',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontStyle: FontStyle.normal,
          ),
        ),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  Future<String> getRepertoire() async {
    var repertoire = await getApplicationDocumentsDirectory();
    var path = repertoire.path;
    return path;
  }

  onFormSubmit() async {
    Map<String, dynamic> pieceString = storage.getItem('tchaPiece');
    Map<String, dynamic> utilisateurString = storage.getItem('tchaUtilisateur');
    Piece piece = Piece.fromMap(pieceString);
    Utilisateur utilisateur = Utilisateur.fromMap(utilisateurString);
    if (this.image != null) {
      String root = await getRepertoire();
      print(root);
      print(this.image!.path);
      int longueur = this.image!.path.split('.').length;
      String extension = this.image!.path.split('.')[longueur - 1];
      print(extension);
      String location = root + '/pp-' + piece.id! + '.' + extension;
      String nom = '/pp-' + piece.id! + '.' + extension;
      print(location);

      File photoLocale = await this.image!.copy(location);
      firebase_storage.UploadTask? task = await uploadFile(this.image, nom);

      if (task != null) {
        print('Envoi en cours...');
        isEnCoursEnvoi = true;
        setState(() {
          isEnCoursEnvoi = true;
        });
        task.whenComplete(() => {
              print('Envoi terminé'),
              ref!.getDownloadURL().then((value) => {
                    print('URL de la photo'),
                    print(value),
                    piece.url = value,
                    storage.setItem('tchaPiece', piece.toMap()),
                    utilisateur.statut = 1,
                    utilisateursFirebase
                        .doc(utilisateur.id)
                        .set(utilisateur.toMap())
                        .then((value) => {
                              storage.setItem(
                                  'tchaUtilisateur', utilisateur.toMap()),
                              piecesFirebase
                                  .doc(piece.id)
                                  .set(piece.toMap())
                                  .then((value) => {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  UploadterminePage()),
                                        ).then((result) {
                                          isEnCoursEnvoi = false;
                                          setState(() {
                                            isEnCoursEnvoi = false;
                                          });
                                        }),
                                      }),
                            }),
                  }),
            });
      }
    }
  }
}
