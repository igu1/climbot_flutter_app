// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'dart:async';

import 'package:esptouch_flutter/esptouch_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:network_info_plus/network_info_plus.dart';

void main() => runApp(EspCon());

class EspCon extends StatefulWidget {
  @override
  _EspConState createState() => _EspConState();
}

class _EspConState extends State<EspCon> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController ssid = TextEditingController();
  final TextEditingController bssid = TextEditingController();
  final TextEditingController password = TextEditingController();
  ESPTouchPacket packet = ESPTouchPacket.broadcast;
  @override
  void dispose() {
    ssid.dispose();
    bssid.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          'Connect Your ESP',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Builder(builder: (context) => Center(child: form(context))),
    );
  }

  bool fetchingWifiInfo = false;

  void fetchWifiInfo() async {
    setState(() => fetchingWifiInfo = true);
    try {
      ssid.text = await NetworkInfo().getWifiName() ?? '';
      bssid.text = await NetworkInfo().getWifiBSSID() ?? '';
    } finally {
      setState(() => fetchingWifiInfo = false);
    }
  }

  createTask() {
    return ESPTouchTask(
        ssid: ssid.text,
        bssid: bssid.text,
        password: password.text,
        packet: packet,
        taskParameter: ESPTouchTaskParameter().copyWith(repeat: 1));
  }

  Widget form(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          Center(
            child: OutlinedButton(
              onPressed: fetchingWifiInfo ? null : fetchWifiInfo,
              child: Text(
                fetchingWifiInfo ? 'Fetching WiFi info' : 'Use current Wi-Fi',
              ),
            ),
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your SSID';
              }
              bool containsQuotesvalue = value.contains('"');
              if (containsQuotesvalue) {
                return 'SSID cannot contain quotes';
              }
              return null;
            },
            controller: ssid,
            decoration: const InputDecoration(
              labelText: 'SSID',
              hintText: 'Tony\'s iPhone',
              helperText: helperSSID,
            ),
          ),
          TextFormField(
            controller: bssid,
            decoration: const InputDecoration(
              labelText: 'BSSID',
              hintText: '00:a0:c9:14:c8:29',
              helperText: helperBSSID,
            ),
          ),
          TextFormField(
            controller: password,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: r'V3Ry.S4F3-P@$$w0rD',
              helperText: helperPassword,
            ),
          ),
          RadioListTile(
            title: Text('Broadcast'),
            value: ESPTouchPacket.broadcast,
            groupValue: packet,
            onChanged: setPacket,
            activeColor: color,
          ),
          RadioListTile(
            title: Text('Multicast'),
            value: ESPTouchPacket.multicast,
            groupValue: packet,
            onChanged: setPacket,
            activeColor: color,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskRoute(task: createTask()),
                    ),
                  );
                }
              },
              child: const Text('Execute'),
            ),
          ),
        ],
      ),
    );
  }

  void setPacket(ESPTouchPacket? packet) {
    if (packet == null) return;
    setState(() {
      this.packet = packet;
    });
  }
}

class TaskRoute extends StatefulWidget {
  TaskRoute({required this.task});

  final ESPTouchTask task;

  @override
  State<StatefulWidget> createState() => TaskRouteState();
}

class TaskRouteState extends State<TaskRoute> {
  late final Stream<ESPTouchResult> stream;
  late final StreamSubscription<ESPTouchResult> streamSubscription;
  late final Timer timer;

  final List<ESPTouchResult> results = [];

  @override
  void initState() {
    stream = widget.task.execute();
    streamSubscription = stream.listen(results.add);
    final receiving = widget.task.taskParameter.waitUdpReceiving;
    final sending = widget.task.taskParameter.waitUdpSending;
    final cancelLatestAfter = receiving + sending;
    timer = Timer(
      cancelLatestAfter,
      () {
        streamSubscription.cancel();
        if (results.isEmpty && mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('No devices found'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
    );
    super.initState();
  }

  @override
  dispose() {
    timer.cancel();
    streamSubscription.cancel();
    super.dispose();
  }

  Widget waitingState(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          Lottie.network(
              'https://assets3.lottiefiles.com/temp/lf20_JA7Fsb.json',
              width: 350),
          SizedBox(height: 16),
          Text('Waiting for results'),
        ],
      ),
    );
  }

  Widget error(BuildContext context, String s) {
    return Center(child: Text(s, style: TextStyle(color: Colors.red)));
  }

  copyValue(BuildContext context, String label, String v) {
    return () {
      Clipboard.setData(ClipboardData(text: v));
      final snackBar = SnackBar(content: Text('Copied $label to clipboard $v'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    };
  }

  Widget noneState(BuildContext context) {
    return Text('None');
  }

  Widget resultList(BuildContext context) {
    final ESPTouchResult data = results[0];
    return Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            Lottie.network(
                'https://assets3.lottiefiles.com/packages/lf20_w5oe9omf.json',
                width: MediaQuery.of(context).size.width),
            Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade200,
                ),
                child: Column(
                  children: [
                    Text(
                      "Connection Established!",
                      style: GoogleFonts.robotoSerif(
                          fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                    Divider(),
                    SizedBox(height: 16),
                    Text(
                      'ESP Device Details:',
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "IP: ${data.ip}",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.robotoSerif(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "BSSID: ${data.bssid}",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.robotoSerif(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amberAccent),
                          elevation: MaterialStateProperty.all(0),
                          fixedSize: MaterialStateProperty.all(
                            Size(MediaQuery.of(context).size.width * 0.8, 40),
                          )),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Done!'),
                    ),
                  ],
                ))
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task'),
      ),
      body: StreamBuilder<ESPTouchResult>(
        builder: (context, AsyncSnapshot<ESPTouchResult> snapshot) {
          if (snapshot.hasError) {
            return error(context, 'Error in StreamBuilder');
          }
          if (!snapshot.hasData) {
            final primaryColor = Theme.of(context).primaryColor;
            return Center(
                child: Lottie.network(
                    'https://assets3.lottiefiles.com/temp/lf20_JA7Fsb.json',
                    width: 350));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return resultList(context);
            case ConnectionState.none:
              return noneState(context);
            case ConnectionState.done:
              return resultList(context);
            case ConnectionState.waiting:
              return waitingState(context);
          }
        },
        stream: stream,
      ),
    );
  }
}

const helperSSID = "SSID is the technical term for a network name. "
    "When you set up a wireless home network, "
    "you give it a name to distinguish it from other networks in your neighbourhood.";
const helperBSSID =
    "BSSID is the MAC address of the wireless access point (router).";
const helperPassword = "The password of the Wi-Fi network";

// class SimpleWifiInfo {
//   static const platform =
//       MethodChannel('eng.smaho.com/esptouch_plugin/example');
//   static Future<String?> get ssid => platform.invokeMethod('ssid');

//   static Future<String?> get bssid => platform.invokeMethod('bssid');
// }
