import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:for_better_soil_and_water/bluetooth_state.dart';
import 'package:for_better_soil_and_water/sensor.dart';

class WaterSoilPage extends StatelessWidget {
  final String title;
  final String desc;
  final BluetoothDevice device;

  const WaterSoilPage(
      {Key? key, required this.title, required this.desc, required this.device})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('$title Page'),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(50),
                child: Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              Container(
                width: 250,
                padding: EdgeInsets.all(10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SensorPage(
                          device: device,
                          test_type: 'heat',
                          for_: title,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Heat',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 250,
                padding: EdgeInsets.all(10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SensorPage(
                          device: device,
                          test_type: 'salinity',
                          for_: title,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Salinity',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 250,
                padding: EdgeInsets.all(10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.all(16.0),
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SensorPage(
                          device: device,
                          test_type: 'acidity',
                          for_: title,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Acidity',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
