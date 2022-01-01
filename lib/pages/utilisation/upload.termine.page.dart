import 'package:flutter/material.dart';
import 'package:tchakolo/composants/composants.all.dart';

class UploadterminePage extends StatefulWidget {
  const UploadterminePage({Key? key}) : super(key: key);

  @override
  _UploadterminePageState createState() => _UploadterminePageState();
}

class _UploadterminePageState extends State<UploadterminePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 50,
        left: 0,
        right: 0,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          margin: EdgeInsets.only(
            bottom: 8,
            left: 32,
            right: 32,
          ),
          width: double.infinity,
          child: Container(
            child: Text(
              "Votre pièce a bien été reçue",
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
          margin: EdgeInsets.only(bottom: 16, top: 20),
          child: Text(
            "Quisque nec volutpat dui, eget porttitor justo. Vivamus euismod eu ipsum a pellentesque. Eget porttitor just euismod eu ipsum a pellentesque.",
            textAlign: TextAlign.left,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 8,
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/tabs',
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
              "Revenir à l'accueil",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
