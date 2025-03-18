import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _subtractCounter() {
    setState(() {
      _counter--;
    });
  }

  Position? armazenarlocalizacao;

  Future<void> buscarGeolocalizacao() async {
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error('Os serviços de localização estão desativados!');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permissões de localização negadas!');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'As permissões de localização são negadas permanentemente, não podemos solicitar permissões!');
    }

    Position localizacao = await Geolocator.getCurrentPosition();
    setState(() {
      armazenarlocalizacao = localizacao;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                buscarGeolocalizacao();
              },
              icon: const Icon(
                Icons.location_on_sharp,
                size: 90,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 30),
            const Text(
              'Pode brincar, é divertido:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (armazenarlocalizacao != null) ...[
              Text(
                'A localização do jogador é ${armazenarlocalizacao?.latitude} e ${armazenarlocalizacao?.longitude}',
              ),
            ]
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          SizedBox(width: 35),
          FloatingActionButton(
            onPressed: _subtractCounter,
            tooltip: 'Increment',
            child: Icon(
              Icons.remove,
            ),
            heroTag: '1',
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.65),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
            heroTag: '2',
          ),
        ],
      ),
    );
  }
}
