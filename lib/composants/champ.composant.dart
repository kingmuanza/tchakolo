import 'package:flutter/material.dart';

/* NORMAL */
class Champ extends StatefulWidget {
  final String libelle;
  int? multiline;
  final TextEditingController leControleur;
  final Widget? bouton;
  final bool? disabled;
  final bool? readOnly;
  final TextInputType? clavier;
  final String? Function(dynamic)? validator;
  Color contourFocusOut = Color(0xFFf0f0f0);
  Color contourFocusIn = Color(0xff120f3e);

  Champ({
    Key? key,
    required this.libelle,
    required this.leControleur,
    this.validator,
    this.bouton,
    this.disabled,
    this.clavier,
    this.multiline,
    this.readOnly,
  }) : super(key: key);

  @override
  _ChampState createState() => _ChampState();
}

class _ChampState extends State<Champ> {
  String? nonNullValidator(value) {
    if (widget.validator != null) {
      return widget.validator!(value);
    }
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    return null;
  }

  bool valide = false;

  changerEnVert() {
    widget.contourFocusOut = Color(0xff9dcd21);
    widget.contourFocusIn = Color(0xff9dcd21);
    setState(() {
      widget.contourFocusOut = Color(0xff9dcd21);
      widget.contourFocusIn = Color(0xff9dcd21);
    });
  }

  changerRouge() {
    widget.contourFocusOut = Color(0xFFf0f0f0);
    widget.contourFocusIn = Colors.red;
    setState(() {
      widget.contourFocusOut = Color(0xFFf0f0f0);
      widget.contourFocusIn = Colors.red;
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint('Début du champ texte ' + widget.libelle);
  }

  @override
  Widget build(BuildContext context) {
    var value = widget.leControleur.text;
    if (nonNullValidator(value) == null) {
      debugPrint(value);
      changerEnVert();
    } else {
      changerRouge();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: widget.disabled != null && widget.disabled!
            ? Colors.grey.shade100
            : Colors.transparent,
      ),
      child: TextFormField(
        validator: nonNullValidator,
        enabled: !(widget.disabled != null && widget.disabled!),
        maxLines: widget.multiline,
        readOnly: widget.readOnly != null ? widget.readOnly! : false,
        controller: widget.leControleur,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          height: 1,
        ),
        keyboardType: widget.clavier,
        onChanged: (value) => {
          if (nonNullValidator(value) == null)
            {
              debugPrint(value),
              changerEnVert(),
            }
          else
            {
              changerRouge(),
            }
        },
        decoration: InputDecoration(
          hintText: widget.libelle,
          suffixIcon: widget.bouton != null ? widget.bouton : null,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.contourFocusIn, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.contourFocusOut, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFf0f0f0), width: 1),
          ),
          contentPadding: EdgeInsets.only(
            top: widget.multiline != null ? 32 : 0,
            left: 20,
            right: 10,
          ),
        ),
      ),
    );
  }
}

/* PASSWORD */
class ChampPassword extends StatefulWidget {
  final String libelle;
  final TextEditingController leControleur;
  final Widget? bouton;
  final bool? disabled;
  final TextInputType? clavier;
  final String? Function(dynamic) validator;
  bool obscureText = true;

  ChampPassword({
    Key? key,
    required this.libelle,
    required this.leControleur,
    required this.validator,
    this.bouton,
    this.disabled,
    this.clavier,
  }) : super(key: key);

  @override
  _ChampPasswordState createState() => _ChampPasswordState();
}

class _ChampPasswordState extends State<ChampPassword> {
  String? nonNullValidator(value) {
    return widget.validator(value);
  }

  void _toggle() {
    setState(() {
      widget.obscureText = !widget.obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: widget.disabled != null && widget.disabled!
            ? Colors.grey.shade100
            : Colors.transparent,
      ),
      child: TextFormField(
        validator: nonNullValidator,
        enabled: !(widget.disabled != null && widget.disabled!),
        obscureText: widget.obscureText,
        controller: widget.leControleur,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          height: 1,
        ),
        keyboardType: widget.clavier,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              widget.obscureText ? Icons.visibility : Icons.visibility_off,
              color: Color(0xff9dcd21),
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              _toggle();
            },
          ),
          hintText: widget.libelle,
          suffix: widget.bouton != null
              ? IconButton(
                  icon: Icon(Icons.calendar_today_outlined),
                  onPressed: () {},
                )
              : null,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff120f3e), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFf0f0f0), width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFf0f0f0), width: 1),
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 10,
          ),
        ),
      ),
    );
  }
}

class ChampSelect extends StatefulWidget {
  String dropdownValue;
  final String libelle;
  final List<DropdownMenuItem<String>> items;
  final void Function(String? newValue) onChanged;
  Color contourFocusOut = Color(0xFFf0f0f0);
  Color contourFocusIn = Color(0xff120f3e);

  ChampSelect({
    Key? key,
    required this.dropdownValue,
    required this.libelle,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ChampSelectState createState() => _ChampSelectState();
}

class _ChampSelectState extends State<ChampSelect> {
  String? nonNullValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Champ obligatoire';
    }
    return null;
  }

  bool valide = false;

  changerEnVert() {
    widget.contourFocusOut = Color(0xff9dcd21);
    widget.contourFocusIn = Color(0xff9dcd21);
    setState(() {
      widget.contourFocusOut = Color(0xff9dcd21);
      widget.contourFocusIn = Color(0xff9dcd21);
    });
  }

  changerRouge() {
    widget.contourFocusOut = Color(0xFFf0f0f0);
    widget.contourFocusIn = Colors.red;
    setState(() {
      widget.contourFocusOut = Color(0xFFf0f0f0);
      widget.contourFocusIn = Colors.red;
    });
  }

  @override
  Widget build(BuildContext context) {
    var value = widget.dropdownValue;
    if (nonNullValidator(value) == null) {
      debugPrint(value);
      changerEnVert();
    } else {
      changerRouge();
    }

    return DropdownButtonFormField<String>(
      hint: Text("Votre pièce d'identification"),
      isExpanded: true,
      value: widget.dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        height: 1,
      ),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.libelle,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.contourFocusIn, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget.contourFocusOut, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFf0f0f0), width: 1),
        ),
        contentPadding: EdgeInsets.only(
          left: 20,
          right: 10,
        ),
      ),
      items: widget.items,
    );
  }
}
