import 'package:flutter/material.dart';
import 'package:gestion_espacios_app/screens/public/buzon_screen.dart';
import 'package:gestion_espacios_app/screens/public/espacios_screen.dart';
import 'package:gestion_espacios_app/screens/public/inicio_screen.dart';
import 'package:gestion_espacios_app/screens/public/perfil_screen.dart';
import 'package:gestion_espacios_app/widgets/bottomnav_widget.dart';
import 'package:gestion_espacios_app/widgets/drawer_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static final List<Widget> _widgetOptions = <Widget>[
    const InicioScreen(),
    const EspaciosScreen(),
    const BuzonScreen(),
    const PerfilScreen()
  ];

  void _onItemTapped(int index) {
    if (index == 3) {
      _scaffoldKey.currentState?.openDrawer();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }

    setState(() {
      _selectedIndex = index;
    });
    if (index == 3) {
      _scaffoldKey.currentState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      drawer: const MyDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
