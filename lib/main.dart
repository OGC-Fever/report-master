import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

var reporList = Map.unmodifiable({
  "臺北市警察局": "0911-510-914",
  "新北市警察局": "0912-095-110",
  "桃園市警察局": "0917-110-880",
  "臺中市警察局": "0911-510-915",
  "臺南市警察局": "0911-510-916",
  "高雄市警察局": "0911-510-917",
  "基隆市警察局": "0911-510-918",
  "新竹市警察局": "0911-510-919",
  "嘉義市警察局": "0911-510-920",
  "新竹縣警察局": "0911-510-921",
  "苗栗縣警察局": "0911-510-922",
  "彰化縣警察局": "0911-510-933",
  "南投縣警察局": "0911-510-923",
  "雲林縣警察局": "0911-510-924",
  "嘉義縣警察局": "0911-510-925",
  "屏東縣警察局": "0911-510-926",
  "宜蘭縣警察局": "0911-510-927",
  "花蓮縣警察局": "0911-510-928",
  "臺東縣警察局": "0911-510-929",
  "澎湖縣警察局": "0911-510-930",
  "金門縣警察局": "0911-510-931",
  "連江縣警察局": "0911-510-932"
});

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _counter = 0;
  var _tmp = [];
  void _incrementCounter() {
    getData().then((value) {
      _tmp = value;
    });
    if (kDebugMode) {
      print(_tmp);
    }
    setState(() {
      _counter++;
    });
  }

  Future<List> getData() async {
    await Geolocator.isLocationServiceEnabled().then((value) {
      if (value == false) {
        Geolocator.openLocationSettings();
      }
    });
    Geolocator.checkPermission().then((value) {
      if (value == LocationPermission.denied) {
        Geolocator.requestPermission();
        //   showDialog(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return const AlertDialog(
        //           title: Text("Success"),
        //           content: Text("Save successfully"),
        //         );
        //       });
      }
    });
    var currentLocation = await Geolocator.getCurrentPosition()
        .timeout(const Duration(seconds: 0), onTimeout: (() {
      return Geolocator.getLastKnownPosition().then((value) {
        if (!value!.isMocked) {
          return value;
        }
        return Position(
            accuracy: 0,
            altitude: 0,
            heading: 0,
            latitude: 0,
            longitude: 0,
            speed: 0,
            speedAccuracy: 0,
            timestamp: DateTime.now());
      });
    }));
    var placemarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);

    var officer = "";
    var tel = "";
    for (var item in reporList.entries) {
      if (placemarks.first.street
          .toString()
          .contains(item.key.substring(0, 2))) {
        officer = item.key;
        tel = item.value;
      }
    }
    return [
      currentLocation.toString(),
      placemarks.first.street.toString(),
      officer,
      tel
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Master"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
