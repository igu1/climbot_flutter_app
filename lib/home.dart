// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, depend_on_referenced_packages, unused_field, unnecessary_brace_in_string_interps, avoid_print, prefer_const_literals_to_create_immutables, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'dart:convert';

import 'package:climbot/login.dart';
import 'package:climbot/providers/theme_provider.dart';
import "package:persistent_bottom_nav_bar/persistent_tab_view.dart";
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map.dart';
import 'espcon.dart';
import 'settings.dart';
import 'package:gsheets/gsheets.dart';
import 'package:provider/provider.dart';
import 'DataScreen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences prefs;

  late List<dynamic> current_location = location_and_celcies[0];

  List<List> location_and_celcies = [];

  final _spreadsheetId = '1negyjhs6ZYD79HbvEnPwEW2WvSo4E3KoWBZgIU6kpsU';

  final _credentials = r'''
{
  "type": "service_account",
  "project_id": "eco-rune-388210",
  "private_key_id": "9fe51520afb2d56708c0fec1e71ff82b3792a762",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCmxkZn135FlJ9j\nSIUQosDh2qS/nFwk3txqSXYGIKCBu7rdsbf3gj2aaal4kpJYSh0WOiPYiMnkF8xD\nye22pjQYmNUiqrKO6qPQlUASzd0dLvwU4lWyE1u/tPHv6W5KCxCKZAnCzmxltErH\n54svS+2IjCWJq1N5Gg4ROpzyfIWXP9XmMwJ+p8hPHoYMhmUQPyclYxlZF0d3gYHM\nbqxu2ICi+mz2rKOLeb2rASM8iQP1RaX3ML00fAV42d69A7Keb2YxEjuNE6WYELGl\n61FxN7L9XSbn804hdm/zsqG2vI1BxTDCgqyrFNSeQxLbL/2whk/sg9FjaIqFzmmY\n6mBbXDFxAgMBAAECggEAJARXCS8TUKCXyX/MaPrVMBGhmdYBWl8c+AFUcV9TeqEZ\n6q3qXpQsjK/8DxOMcm/TF01IF4f3HgD7troh0dvUDWnYQcvekxnedfn9o/H8qkRO\n4Y291x7yJhVEWL0veeMo19Jh/0XISDCnI8QAHZ9GtcIai0BKXzF+zz66zW2SBkdE\nHqjKKmbEtTuPpM6pJk2HTC7yBSmQfAu0S/ocrUVgIxL3yEILMurhhlISIKus0WCz\nqa1f5QmaHbWI19s28TAzy2k1lKX+qGUsDZJdBRMK7CUKnREsalxKsr3TNlpPmjt9\nd3twR2Iyd7q3oXYFSQFGlw11/tsZsYRS9nD/FNVzzwKBgQDaX8OLZouraYywNOaG\no9aC71MWn4T+nIZbfA1Abs/AQ57abaA3K3ghfH83rebO09hQf9HcYlfjdm9CfBZF\nQfcakzL21Uj5pMW/MbUulBB4FfZmGlK+9hRVqrv6slLoB7kbVgcfeA7ysOv3wfMy\n3n/p1ByWg8Pwl4HwGoikXY8OcwKBgQDDgoMX3E4WHSysu2TCj3xtYBowrtplegnJ\nBBJLt1uqbvJ4GLX5s50lCUzMY2GU23ACku0UfTY5/NoSsR9eweRzBJ4XNB0y7fgW\n8y1vOuGKFk/LqaoL4ae89BQy8nqFkrEeWbNYsd7OsUcXjNvCCdwU5SIy0/mQ4pGY\nkCKi02wDiwKBgEP6RZPycw4ECGCdxxkojVErEPFc7PiZXxXBcxqYpCFUq3GRaKtj\n47yA1dVOVCgUOCUu9PQmxPcw2geXOxOKKlLieZ3u3Q2hZlFTNvRt8QaAx7gW/6Uk\nU0YrpOKwejBynwPMbuEz7WtM+dehT4SJUMZIWjHciLUvZKqKh/iqiyrTAoGAJEaT\nDFpUIsZHA8XBbFgzPhgWw/GtlCaQqjuXKXVcDMOJOb9cBHjPL5AKL+JAuN3+anvY\ngXS6GwhPbihvKaXQPYcdzjBdOpXs8lUsmPbT4ktBgwh4BLxZ4zVmig1zrlUJiBgc\nrthR/wflqPj5zYcGztm0/rlWFQv099nGk2+nGwECgYAixsIo65yRBcViGhzAbYmJ\nbaoEhg0rm2H2puZ/KJ2lgaOVoh77rGNBgAsJumSBH1pQfhy5lW25wNiiFOdmRC8o\nVYAP+7p96cfKpYuCapuxfpCdZ0pgRyGMcQFapMw1A+NUDHPuu2kdrqY1+GiUo13A\nDl0Q5uvf8uACo0U3f/CGNA==\n-----END PRIVATE KEY-----\n",
  "client_email": "climbot@eco-rune-388210.iam.gserviceaccount.com",
  "client_id": "117052138691004838408",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/climbot%40eco-rune-388210.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

  @override
  void initState() {
    super.initState();
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      print("User Logged -> ${firebaseUser.email}");
      _IntialupdateWeatherData();
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
    setPreferences();
  }

  void setPreferences() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstOn', false);
  }

  @override
  void dispose() {
    super.dispose();
    _homecontroller.dispose();
    _controller.dispose();
  }

  Future<dynamic> getData() async {
    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    final sheet = ss.worksheetByTitle('Station_Logs');
    final rows = await sheet!.values.allRows(fromRow: 2, fromColumn: 1);
    return rows;
  }

  Future<dynamic> getFirstData(String Station_ID) async {
    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    final sheet = ss.worksheetByTitle(Station_ID);
    final rows = await sheet!.values.allRows(fromRow: 1, fromColumn: 1);
    for (var row in rows) {
      if (row.length == 1) {
        row.add('None');
      }
    }

// Now access the modified values
    var station_name = rows[0];
    var latitude = rows[1];
    var longitude = rows[2];
    var altitude = rows[3];
    var address = rows[4];
    var main_data = rows[6];
    var datas = rows[7];
    var thing = [
      station_name,
      latitude,
      longitude,
      altitude,
      address,
      main_data,
      datas,
    ];
    return thing;
  }

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  late List<List<String>> data = [];

  void _IntialupdateWeatherData() async {
    final jsonData = await getData();
    if (jsonData != null) {
      if (mounted) {
        location_and_celcies = jsonData;
        _updateWeatherData(await getFirstData('PWNKL001'));
      }
    } else {
      print('retrying...');
      _IntialupdateWeatherData();
    }
    setState(() {});
  }

  void _updateWeatherData(jsonData) {
    if (jsonData != null) {
      if (mounted) {
        data = jsonData;
        current_location = data;
      }
    }
    setState(() {});
  }

  final PageController _homecontroller =
      PageController(initialPage: 0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: data.isNotEmpty
          ? PersistentTabView(
              context,
              backgroundColor: Provider.of<ThemeProvider>(context).isDark
                  ? Colors.grey.shade900
                  : Colors.white,
              screens: [
                Home(theme, _homecontroller),
                Data(),
                EspCon(),
                Settings(),
              ],
              items: [
                PersistentBottomNavBarItem(
                    icon: Icon(Icons.home),
                    title: 'Home',
                    activeColorPrimary: Colors.amber,
                    inactiveColorPrimary:
                        theme.isDark ? Colors.white : Colors.blue),
                PersistentBottomNavBarItem(
                    icon: Icon(Icons.map),
                    title: 'Map',
                    activeColorPrimary: Colors.amber,
                    inactiveColorPrimary:
                        theme.isDark ? Colors.white : Colors.blue),
                PersistentBottomNavBarItem(
                    icon: Icon(Icons.perm_device_info),
                    title: 'ESP',
                    activeColorPrimary: Colors.amber,
                    inactiveColorPrimary:
                        theme.isDark ? Colors.white : Colors.blue),
                PersistentBottomNavBarItem(
                    icon: Icon(Icons.settings),
                    title: 'Settings',
                    activeColorPrimary: Colors.amber,
                    inactiveColorPrimary:
                        theme.isDark ? Colors.white : Colors.blue),
              ],
            )
          : Center(
              child: Lottie.network(
                  'https://assets3.lottiefiles.com/temp/lf20_JA7Fsb.json',
                  width: 350)),
    );
  }

  SafeArea Home(theme, PageController _homecontroller) {
    return SafeArea(
      child: PageView.builder(
          itemCount: 2,
          controller: _homecontroller,
          // physics: NeverScrollableScrollPhysics(),
          onPageChanged: (value) {
            print(value);
          },
          itemBuilder: (context, index) {
            return index == 0
                ? HomePage(theme, _homecontroller)
                : DataPage(
                    stationName: current_location[0][1],
                    latitude: current_location[1][1],
                    longitude: current_location[2][1],
                    altitude: current_location[3][1],
                    address: current_location[4][1],
                    liveData: current_location[6],
                  );
          }),
    );
  }

  Container HomePage(theme, PageController _homecontroller) {
    return Container(
      child: Column(children: [
        Expanded(
          child: Flex(
            direction: Axis.vertical,
            children: [
              Flexible(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.only(left: 40, right: 40, top: 30),
                    padding: EdgeInsets.only(bottom: 150),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: theme.isDark
                                ? [
                                    Color.fromARGB(255, 90, 90, 90),
                                    Color.fromARGB(255, 77, 77, 77)
                                  ]
                                : [
                                    Colors.blue
                                        .withBlue(100)
                                        .withRed(1)
                                        .withGreen(50),
                                    Colors.white
                                  ]),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50))),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          data.isNotEmpty
                              ? Text(
                                  current_location[6][1] == 'None'
                                      ? 'No Temprature Found'
                                      : '${current_location[6][1].toString()}°C',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 65,
                                      fontWeight: FontWeight.bold),
                                )
                              : Text(
                                  'Loading...',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 65,
                                      fontWeight: FontWeight.bold),
                                ),
                          Text(
                            current_location[0][1] == 'None'
                                ? 'No Station Name'
                                : current_location[0][1].toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )),
              Flexible(
                  flex: 1,
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: !theme.isDark
                              ? LinearGradient(colors: [
                                  Colors.amber,
                                  Color.fromARGB(255, 244, 214, 126)
                                ])
                              : LinearGradient(colors: [
                                  Color.fromARGB(255, 16, 16, 16),
                                  Colors.grey.shade900
                                ])),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(left: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              current_location[0][1] == 'None'
                                  ? 'No Station Name'
                                  : current_location[0][1].toString(),
                              style: TextStyle(
                                  color: theme.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.keyboard_arrow_right,
                                size: 50,
                              ),
                              onPressed: () {
                                if (_homecontroller.initialPage == 0) {
                                  _homecontroller.nextPage(
                                      duration: Duration(milliseconds: 100),
                                      curve: Curves.easeIn);
                                }
                              },
                            )
                          ],
                        ),
                      ))),
              Flexible(
                  flex: 3,
                  child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(),
                      child: GridView.count(
                        childAspectRatio: (3 / 1),
                        crossAxisCount: 2,
                        children:
                            List.generate(location_and_celcies.length, (index) {
                          return NeumorphicButton(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              onPressed: () async {
                                setState(() {
                                  data = [];
                                });
                                current_location = location_and_celcies[index];
                                // setState(() {
                                //   _updateWeatherData();
                                // });
                                var station_id = location_and_celcies[index][0];
                                print(station_id);
                                final gsheets = GSheets(_credentials);
                                final ss =
                                    await gsheets.spreadsheet(_spreadsheetId);
                                final sheet = ss.worksheetByTitle(station_id);
                                final rows = await sheet!.values
                                    .allRows(fromRow: 1, fromColumn: 1);
                                for (var row in rows) {
                                  if (row.length == 1) {
                                    row.add('None');
                                  }
                                }

// Now access the modified values
                                var station_name = rows[0];
                                var latitude = rows[1];
                                var longitude = rows[2];
                                var altitude = rows[3];
                                var address = rows[4];
                                var main_data = rows[6];
                                var datas = rows[7];
                                var thing = [
                                  station_name,
                                  latitude,
                                  longitude,
                                  altitude,
                                  address,
                                  main_data,
                                  datas,
                                ];
                                _updateWeatherData(thing);
                              },
                              style: NeumorphicStyle(
                                  shape: NeumorphicShape.flat,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(8)),
                                  intensity: theme.isDark ? 0 : 1),
                              padding: const EdgeInsets.all(12.0),
                              child: Center(
                                child: Text(
                                  location_and_celcies[index][1].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    color: Colors.black,
                                  ),
                                ),
                              ));
                        }),
                      ))),
            ],
          ),
        )
      ]),
    );
  }
}
