import 'package:flutter/material.dart';
import 'package:polar/polar.dart';

void main() {
  runApp(const MyApp());
}

/// Example app
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const identifier = 'B2178924';

  final polar = Polar();
  final logs = ['Service started'];

  @override
  void initState() {
    super.initState();

    polar.heartRateStream.listen((e) => log('Heart rate: ${e.data.hr}'));
    polar.batteryLevelStream.listen((e) => log('Battery: ${e.level}'));
    polar.streamingFeaturesReadyStream.listen((e) {
      log(e.features.toString());
      if (e.features.contains(DeviceStreamingFeature.ecg)) {
        polar
            .startEcgStreaming(e.identifier)
            .listen((e) => log('ECG data: ${e.samples}'));
      } else if (e.features.contains(DeviceStreamingFeature.ppi)) {
        polar.startOhrPPIStreaming(identifier).listen((event) {
          log('PPG: ${event.timeStamp} => ${event.samples.map((e) => '[${e.ppi}, ${e.hr}]').reduce((value, element) => value + element)}');
        });
      }
    });
    polar.deviceConnectingStream.listen((_) => log('Device connecting'));
    polar.deviceConnectedStream.listen((_) => log('Device connected'));
    polar.deviceDisconnectedStream.listen((_) => log('Device disconnected'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Polar example app'),
          actions: [
            IconButton(
              icon: const Icon(Icons.stop),
              onPressed: () {
                log('Disconnecting from device: $identifier');
                polar.disconnectFromDevice(identifier);
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                log('Connecting to device: $identifier');
                polar.connectToDevice(identifier);
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(10),
          shrinkWrap: true,
          children: logs.reversed.map((e) => Text(e)).toList(),
        ),
      ),
    );
  }

  void log(String log) {
    // ignore: avoid_print
    print(log);
    setState(() {
      logs.add(log);
    });
  }
}
