import 'package:flutter/material.dart';
import 'package:tchakolo/composants/composants.all.dart';

class ConditionsUtilisation extends StatefulWidget {
  const ConditionsUtilisation({Key? key}) : super(key: key);

  @override
  _ConditionsUtilisationState createState() => _ConditionsUtilisationState();
}

class _ConditionsUtilisationState extends State<ConditionsUtilisation> {
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
          children: [
            Titre(texte: "Conditions d'utilisation"),
            SousTitre(
                texte:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean est mi, sodales sit amet odio ac, sollicitudin volutpat dui. Curabitur ex velit, lacinia a congue ac, vestibulum ac felis. Donec sed tincidunt augue, in porta ligula. Suspendisse scelerisque, ligula id pharetra rhoncus, nisi sem mattis magna, nec pharetra mi nibh vitae ligula. Aenean dignissim ullamcorper diam eu gravida. Vivamus hendrerit lorem eget ipsum viverra, tincidunt rhoncus lorem semper. Nunc varius odio a vulputate accumsan. Morbi commodo eros quis lectus posuere pretium. Nullam aliquet tellus quis purus blandit tempor. Phasellus posuere, justo eu eleifend malesuada, sapien diam fermentum turpis, at suscipit felis urna vel diam. Etiam eget lorem vel nibh molestie accumsan. Vivamus blandit mi id metus imperdiet ultricies. Suspendisse cursus vestibulum sem, nec semper diam vehicula eget."),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 8,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Color(0xff9dcd21),
                  minimumSize: Size.fromHeight(
                    50,
                  ), // fromHeight use double.infinity as width and 40 is the height
                ),
                child: Text(
                  "J'ai lu",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
