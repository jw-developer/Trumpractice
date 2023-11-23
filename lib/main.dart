import 'package:flutter/material.dart';
import 'package:trumpractice/favoriten.dart';
import 'package:trumpractice/homescreen.dart';
import 'package:trumpractice/infos.dart';
import 'package:trumpractice/utils/styles.dart';


// ruft App auf
void main() {
  runApp(const MyApp(backScreen: 0,));
}

class MyApp extends StatefulWidget {
  final int backScreen;

  const MyApp({super.key, required this.backScreen});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedPageIndex = widget.backScreen;

    setState(() {
      getFavorits(); // holt Favoriten aus dem lokalen Speicher des Handys
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Trumpractice',
      theme: ThemeData(
        primaryColor: Styles.mainColor, // Hauptfarbe festlegen

        appBarTheme: AppBarTheme(
            toolbarHeight: 0,
            elevation: 0,
            backgroundColor: Styles.mainColor,
        ),

        scaffoldBackgroundColor: Styles.whiteColor,

        navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Styles.whiteColor,
            elevation: 16,
            indicatorColor: Styles.mainColor.withOpacity(0),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            labelTextStyle: MaterialStateProperty.all(TextStyle(fontSize: 13, color: Styles.textColor, fontWeight: FontWeight.w400))
        ),
      ),

      home: Scaffold(
        appBar: AppBar(), // füllt Platz bei der Notch/Dynamic Island aus

        // je nach dem auf welchem Punkt (NavBar) man ist, wird ein anderes Widget angezeigt
        body: [
          HomeScreen(),
          const Favoriten(),
          const Infos(),
        ] [selectedPageIndex],

        // NavigationsBar unten
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
          },

          destinations: const <NavigationDestination>[
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.favorite),
              icon: Icon(Icons.favorite_outline),
              label: "Favoriten",
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.info),
              icon: Icon(Icons.info_outline),
              label: "Info",
            ),
          ],
        ),
      ),
    );
  }
}

