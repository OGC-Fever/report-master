import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:report_master/officer_list.dart';

class ReportVM extends ChangeNotifier {
  var reportList = ["紅線停車", "併排停車", "自訂"].map((value) {
    return DropdownMenuItem(child: Text(value), value: value);
  });
  var chooseValue = "紅線停車";
  var plateController = TextEditingController();
  var smsController = TextEditingController();
  var address = "";
  var sms = "";

  void check() {
    if (kDebugMode) {
      print("chooseValue" + chooseValue);
      print("address" + address);
      print("sms" + sms);
      print("smsController" + smsController.text);
    }
  }

  void renew() {
    if (chooseValue == "自訂") {
      chooseValue = "";
    }
    smsController.text = "${plateController.text}\r\n$chooseValue\r\n$address";
    notifyListeners();
    check();
  }

  Future<void> getAddress() async {
    if (kDebugMode) {
      print("hello");
    }
    getData().then((value) {
      try {
        address = value[0];
        sms = value[1];
      } catch (e) {
        sms = "";
        address = "";
      }
      renew();
    });
  }

  void clear() {
    chooseValue = "";
    plateController.text = "";
    address = "";
    sms = "";
    smsController.text = "";
    notifyListeners();
    check();
  }

  void sendSMS() {
    // chooseValue = "";
    // plateController.text = "";
    // address = "";
    // sms = "";
    // smsController.text = "";
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
        .timeout(const Duration(seconds: 5), onTimeout: (() {
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

    var tel = "";
    for (var item in reporList.entries) {
      if (placemarks.first.street
          .toString()
          .contains(item.key.substring(0, 2))) {
        tel = item.value;
      }
    }
    return [placemarks.first.street.toString().substring(5), tel];
  }
}
