// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, unused_field, duplicate_ignore, unused_local_variable, unnecessary_null_comparison

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:google_fonts/google_fonts.dart';

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
  final _spreadsheetId = '1-F6qjn9QVXLvYfPTkKJlDA4IJr1EJCmLtvperIUTHnk';

  final _credentials = r'''
{
  "type": "service_account",
  "project_id": "climbot-database",
  "private_key_id": "b709b3c54a79d13a5a438b56c39d213ac9b2ac0f",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC7jGT4PyKPKZoL\n4DvriiVvvMimbIBF03zd49D615gBlQoMRNw+t/MyYKQ1VahJYyB6wE5p8nUVn/zE\nWkRrkMVJhxb0AudxFPbA2IvsQ8kuNEOl0XLp8l5IITX4/+xbFjM/UZYinjEMVhtj\nz1rkJHHGzlp7sQ35a74MCpB4BCJeEHHJFNFI1RxkqfuPKi3jKW+QpBp0Iq0MCjJL\n8HXPxrihGOfQ8swnzOsjQ4CofhWPR9nCm5g045XYcH8jqPZDwvZT7OnppW68ipEs\nRU7uJBv51g7hx7ND3zG+XpfMOk7A48mnkKqBAFUYMmgZBmzQiHlXpRGpuAZDPwWj\ntTKRO0atAgMBAAECggEACo4xxpkDEGyme2Gg7bZGOh41asxzgbqP7gsa4WtN5lTl\njmA3xx3iRaUTyN6rzImUM+Rr5WGcfl2VQ9XSwP0SZXuBarVZIk+sPZlScrcz9PJD\nFmuN3KXj8YpQ99Urj8rVkow8d3FQ0GFuRDVQ58M3VhmaFRkXcMDEHvhfPin5ZzLL\n4wXEqQHyFhx+JVha55cX/fXER5AhZxIb8aqemFlbHOeHV9L3246+78WNh7BvlNuh\n/UJ2J6dXamt3MM9STGevkDrIUlrEwiUuldi5gZvv1vIB080+i4BOjCnKHwD5Q2Sa\nVlZ42aLXj5UrTxEHUS3PS/QXzTERNDzAUeihYZJGbwKBgQD3rYNJ5KKjbDS2bsMz\nJ89gZ7WFXDOFMBU5kXltiSXJCKaFSGHVtZ0Myn5p730G9O+bjWXulFc4rzNDUQJp\n7IScDYcegibQRYUd82B/OnOqBMIWKbCgotaD22r8xEM1WQkYPWuSHIjAjdmY3mQ2\noKJKI3FGLshDwubCM0/Nk02ZwwKBgQDB2ahilnBgDNuOFRbViNweSVN7AlIhJc2M\ncAYXprkgTLdbL8974Aw6whexwaW8cRpy0wFNcw261u7nD3LMoPPiJBZtLXdBFiu+\n3yG5bzmphi36vr9+kkLNbuIYh49APzob2eZo3CR9J/v0CDADk5crKQBHWSU+VVEc\nWl0LuSMmzwKBgQDHCw6Dh9acdw01v3Xn2opx82aRsjNFSgsEpMBtItbW5LjOTAkz\n8iwwZ1uITwqvWJBm9g+A2H3v8/zCkIvcDFPWBZkdD4OZxQThuQFHvfXOINzJat+j\neLnkZaVpVWCdstv4OwQD/CJ6fITusWrf6+AArNMPj/EpY6yHTS1JDKREeQKBgQCP\neMG4nfF0FXAWO6OXzWBlBg5EN5aDtA/qxiqsLJhNwJngYoVlAJDsmCSjSliZHPjf\nTS5knSfnRhaxauyjaOi4Uc9LZOAjiv47mbfDIAAEaSv0rmLakfPhShUK5KHwghtG\n68Itj+ltvD8tATZQH1c9+W2cYO1AsjKDEppVB+RtXwKBgQCsVmlLxS//zTVVkzA2\nwM1fH0wqMDkAECcm9oHgAedzqoj3hSRLv2ZalPirtOaI3IZUHKm++Kj2xqml6X+D\nrrBd3hi3SmwaaRhuX7t4/7SKvBl94MdC9wofRm8za+FHq+jkWkvruu/Ff+SAWmzQ\nUgy5r7hUSDVuUbUxMJqA5YJBbw==\n-----END PRIVATE KEY-----\n",
  "client_email": "climebot@climbot-database.iam.gserviceaccount.com",
  "client_id": "117978291067442495851",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/climebot%40climbot-database.iam.gserviceaccount.com"
}
''';

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Future<List<Marker>> getDatafromGsheet() async {
    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    final sheet = ss.worksheetByTitle('all');
    final rows = await sheet!.values.allRows(fromRow: 2, fromColumn: 1);

    final markers = await Future.wait(
      rows.map((row) async {
        final lat = double.tryParse(row[2]);
        final lng = double.tryParse(row[1]);
        if (lat != null && lng != null) {
          final bitmap = await getBytesFromAsset('assets/bee.png', 60);
          return Marker(
            markerId: MarkerId(row[0]),
            position: LatLng(lat, lng),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                  Stack(
                    children: [
                      Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                row[0].toString(),
                                style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.montserrat().fontFamily,
                                    fontSize: 20),
                              ),
                              Text(
                                "Latitude: ${row[1]} | Longitude: ${row[2]}",
                                style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: 10,
                                    color: Colors.grey.shade500),
                              ),
                              Divider(),
                              SizedBox(height: 2),
                              Text(
                                "Temperature: ${row[3]}",
                                style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: 16),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Relative Humidity: ${row[4]}",
                                style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: 16),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Pressure: ${row[5]}",
                                style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.poppins().fontFamily,
                                    fontSize: 16),
                              ),
                            ],
                          )),
                      // Positioned(
                      //     bottom: -20,
                      //     left: 150,
                      //     child: Container(
                      //         width: 10,
                      //         height: 10,
                      //         decoration: BoxDecoration(
                      //           color: Colors.red,
                      //           shape: BoxShape.circle,
                      //         )))
                    ],
                  ),
                  LatLng(lat, lng));
            },
            icon: BitmapDescriptor.fromBytes(bitmap),
          );
        }
      }).toList(),
    );
    return markers.whereType<Marker>().toList();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    getDatafromGsheet();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(.42796133580664, 0.085749655962),
    zoom: 10.4746,
  );

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.refresh, color: Colors.white),
      ),
      body: SafeArea(
        child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(20),
            // ignore: prefer_const_constructors
            child: FutureBuilder(
                future: getDatafromGsheet(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          GoogleMap(
                            mapType: MapType.normal,
                            compassEnabled: true,
                            initialCameraPosition: const CameraPosition(
                                target: LatLng(10.850516, 76.271080),
                                zoom: 7.4746),
                            zoomGesturesEnabled: true,
                            onTap: (argument) {
                              _customInfoWindowController.hideInfoWindow!();
                            },
                            onCameraMove: (position) {
                              _customInfoWindowController.onCameraMove!();
                            },
                            mapToolbarEnabled: false,
                            zoomControlsEnabled: false,
                            markers: snapshot.data!.toSet(),
                            onMapCreated: (GoogleMapController controller) {
                              _customInfoWindowController.googleMapController =
                                  controller;
                            },
                          ),
                          CustomInfoWindow(
                            controller: _customInfoWindowController,
                            height: 175,
                            width: 300,
                            offset: 35,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                })),
      ),
    );
  }
}
