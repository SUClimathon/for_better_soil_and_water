import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'result.dart';

class SensorPage extends StatefulWidget {
  final BluetoothDevice device;
  final String testType;
  final String for_;

  const SensorPage(
      {Key? key,
      required this.device,
      required this.testType,
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

  late List _data;

  double _heat = 0;
  double _salinity = 0;
  double _acidity = 0;

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
        title: const Text('Sensors Data'),
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
                        _data = currentValue.split(",");

                        if (_data[0] != "nan") {
                          _heat = double.parse('${_data[0]}');
                        }

                        if (_data[1] != "nan") {
                          _salinity = double.parse('${_data[1]}');
                        }

                        if (_data[1] != "nan") {
                          _acidity = double.parse('${_data[2]}');
                        }

                        return Result(
                          humidity: 50,
                          temperature: 20,
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
