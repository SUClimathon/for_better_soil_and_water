import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'result.dart';

class SensorPage extends StatefulWidget {
  final BluetoothDevice device;
  final String test_type;
  final String for_;

  const SensorPage(
      {Key? key,
      required this.device,
      required this.test_type,
      required this.for_})
      : super(key: key);

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  final service_uuid = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final charaCteristic_uuid = "beb5483e-36e1-4688-b7f5-ea07361b26a8";

  late bool isReady;
  late Stream<List<int>> stream;
  late List _temphumidata;

  double _temp = 0;
  double _humidity = 0;

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  @override
  void dispose() {
    widget.device.disconnect();
    super.dispose();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _pop();
      return;
    }

    Timer(
      const Duration(seconds: 15),
      () {
        if (!isReady) {
          disconnectFromDevice();
          _pop();
        }
      },
    );

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _pop();
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _pop();
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      if (service.uuid.toString() == service_uuid) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == charaCteristic_uuid) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        }
      }
    }

    if (!isReady) {
      _pop();
    }
  }

  _pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dht11 Sensor'),
      ),
      body: Container(
          child: !isReady
              ? const Center(
                  child: Text(
                    "Waiting...",
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  ),
                )
              : Container(
                  child: StreamBuilder<List<int>>(
                    stream: stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<int>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.active) {
                        // geting data from bluetooth
                        var currentValue = _dataParser(snapshot.data!);
                        _temphumidata = currentValue.split(",");

                        if (_temphumidata[0] != "nan") {
                          _temp = double.parse('${_temphumidata[0]}');
                        }

                        if (_temphumidata[1] != "nan") {
                          _humidity = double.parse('${_temphumidata[1]}');
                        }

                        return Result(
                          humidity: _humidity,
                          temperature: _temp,
                        );
                      } else {
                        return const Text('Check the stream');
                      }
                    },
                  ),
                )),
    );
  }
}
