import 'package:flutter/material.dart';

class SousTitre extends StatelessWidget {
  final String texte;
  const SousTitre({
    Key? key,
    required this.texte,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Text(
        texte,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class Titre extends StatelessWidget {
  final String texte;
  const Titre({
    Key? key,
    required this.texte,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Text(
        texte,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xff120f3e),
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
