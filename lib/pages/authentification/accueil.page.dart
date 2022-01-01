import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccueilPage extends StatefulWidget {
  const AccueilPage({Key? key}) : super(key: key);

  @override
  _AccueilPageState createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<Builder> slides = [1, 2, 3].map((i) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          // width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 0),
          // decoration: BoxDecoration(color: Colors.amber),
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 32,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Column(
              children: [
                Image(
                  image: AssetImage('assets/images/logo.jpeg'),
                  height: 220,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas ac lacus nec tortor ornare consectetur',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }).toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(
            top: 0,
            left: 32,
            right: 32,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Bienvenue',
                  style: TextStyle(
                    color: Color(0xff120f3e),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 350.0,
                  aspectRatio: 4 / 3,
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items: slides,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: slides.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == entry.key
                              ? Color.fromRGBO(255, 117, 8, 1)
                              : Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 8,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/inscription',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Color(0xff9dcd21),
                    minimumSize: Size.fromHeight(
                      50,
                    ), // fromHeight use double.infinity as width and 40 is the height
                  ),
                  child: Text(
                    'S\'inscrire',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
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
                    'Se connecter',
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
}
