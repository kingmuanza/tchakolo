import 'package:flutter/material.dart';

class ChampDate extends StatefulWidget {
  DateTime selectedDate = DateTime.now();

  bool isDateChoisie = false;

  bool isShowedDateError = false;

  ChampDate({
    Key? key,
    required this.selectedDate,
    isDateChoisie = false,
    isShowedDateError = false,
  }) : super(key: key);

  @override
  _ChampDateState createState() => _ChampDateState();
}

class _ChampDateState extends State<ChampDate> {
// Le champ date est un peu particulier

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        // locale: Locale('fr', 'FR'),
        context: context,
        initialDate: widget.selectedDate,
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
    if (picked != null && picked != widget.selectedDate) {
      setState(() {
        widget.isDateChoisie = true;
        widget.isShowedDateError = false;
        widget.selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.only(left: 20, top: 0, bottom: 0, right: 12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: widget.isShowedDateError
                      ? Colors.red
                      : Color(0xFFf0f0f0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isDateChoisie
                    ? widget.selectedDate.toIso8601String().split('T')[0]
                    : 'Date de naissance',
                style: TextStyle(
                  color: widget.isDateChoisie ? Colors.black87 : Colors.black54,
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
        widget.isShowedDateError
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
              )
      ],
    );
  }
}
