import 'package:flutter/material.dart';
import 'package:tchakolo/pages/utilisation/credits.page.dart';
import 'package:tchakolo/pages/utilisation/dashboard.page.dart';
import 'package:tchakolo/pages/utilisation/profil.page.dart';

class Tabs extends StatefulWidget {
  const Tabs({Key? key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _selectedIndex = 0;
  final _dashboardScreen = GlobalKey<NavigatorState>();
  final _creditsScreen = GlobalKey<NavigatorState>();
  final _soldeScreen = GlobalKey<NavigatorState>();
  final _profilScreen = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.credit_card),
                label: 'Crédits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.stacked_bar_chart),
                label: 'Solde',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Color.fromRGBO(18, 15, 62, 1),
            unselectedItemColor: Colors.grey,
            onTap: (val) => _onTap(val),
          ),
          body: IndexedStack(
            children: [
              Navigator(
                key: _dashboardScreen,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => DashboardPage(),
                ),
              ),
              Navigator(
                key: _creditsScreen,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => CreditsPage(),
                ),
              ),
              Navigator(
                key: _soldeScreen,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => Profil(),
                ),
              ),
              Navigator(
                key: _profilScreen,
                onGenerateRoute: (route) => MaterialPageRoute(
                  settings: route,
                  builder: (context) => Profil(),
                ),
              ),
            ],
            index: _selectedIndex,
          ) // This trailing comma makes auto-formatting nicer for build methods.
          ),
    );
  }

  void _onTap(int val) {
    if (_selectedIndex == val) {
      switch (val) {
        case 0:
          _dashboardScreen.currentState!.popUntil((route) => route.isFirst);
          break;
        case 1:
          _creditsScreen.currentState!.popUntil((route) => route.isFirst);
          break;
        case 2:
          _profilScreen.currentState!.popUntil((route) => route.isFirst);
          break;
        case 3:
          _profilScreen.currentState!.popUntil((route) => route.isFirst);
          break;
        default:
      }
    } else {
      if (mounted) {
        setState(() {
          _selectedIndex = val;
        });
      }
    }
  }
}
