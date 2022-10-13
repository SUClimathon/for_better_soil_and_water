import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:for_better_soil_and_water/result.dart';

import 'water_soil_page.dart';

class WaterSoil extends StatelessWidget {
  final BluetoothDevice device;

  const WaterSoil({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Home Page',
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                padding: const EdgeInsets.all(30),
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
                        builder: (context) =>
                            Result(temperature: 10, salty: 30, acidity: 20),
                      ),
                    );
                  },
                  child: const Text(
                    'Water',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 250,
                padding: const EdgeInsets.all(30),
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
                        builder: (context) => WaterSoilPage(
                          title: 'Soil',
                          desc: 'Description.......................',
                          device: device,
                          acidity: 50,
                          salty: 50,
                          temperature: 10,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Soil',
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
