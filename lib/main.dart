import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

var reporList = {
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
};

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    getData();
    setState(() {
      _counter++;
    });
  }

  Future<void> getData() async {
    await Geolocator.isLocationServiceEnabled().then((value) {
      if (value == false) {
        Geolocator.openLocationSettings();
      }
    });
    await Geolocator.checkPermission().then((value) {
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
    try {
      var currentLocation = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 0));
      var placemarks = await placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);

      if (kDebugMode) {
        print(currentLocation);
        print(placemarks.first.street);
      }
    } catch (e) {
      Geolocator.getLastKnownPosition().then((value) async {
        var placemarks =
            await placemarkFromCoordinates(value!.latitude, value.longitude);
        if (kDebugMode) {
          var add = placemarks.first.street.toString();
          print(add);
          for (var item in reporList.entries) {
            if (add.contains(item.key.substring(0, 2))) {
              print(item.key);
              print(item.value);
            }
          }
        }
      });
    }
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
