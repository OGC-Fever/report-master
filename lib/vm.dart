import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:report_master/officer_list.dart';
import 'package:flutter_sms/flutter_sms.dart';

class ReportVM extends ChangeNotifier {
  var reportList =
      ["紅線停車", "路口轉角停車", "併排停車", "公車站違停", "佔用身障車格", "其它"].map((value) {
    return DropdownMenuItem(child: Text(value), value: value);
  });
  String? chooseValue;

  var plateController = TextEditingController();
  var smsController = TextEditingController();
  var address = "";
  var sms = "";
  var sendable = false;

  void check() {
    if (plateController.text.isNotEmpty &&
        address.isNotEmpty &&
        sms.isNotEmpty &&
        smsController.text.isNotEmpty) {
      sendable = true;
    } else {
      sendable = false;
    }
  }

  void renew() {
    String? item = "";
    if (chooseValue == "其它" || chooseValue == null) {
      item = "";
    } else {
      item = chooseValue;
    }
    smsController.text = "${plateController.text}\r\n$item\r\n$address";
    check();
    notifyListeners();
  }

  Future<void> getAddress(var context) async {
    showDialog(
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          alignment: Alignment.center,
          content: Text("Getting Address..."),
        );
      },
      context: context,
    );
    getData().then((value) {
      address = value[0];
      sms = value[1];
      renew();
    }).whenComplete(() {
      Navigator.pop(context);
    });
  }

  void clear() {
    chooseValue = null;
    plateController.text = "";
    address = "";
    sms = "";
    smsController.text = "";
    check();
    notifyListeners();
  }

  Future<void> sendingSMS() async {
    await sendSMS(message: smsController.text, recipients: [sms]);
    sendable = false;
    notifyListeners();
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
      }
    });
    var currentLocation = await Geolocator.getCurrentPosition()
        .timeout(const Duration(seconds: 5), onTimeout: (() {
      return Geolocator.getLastKnownPosition().then((value) {
        return value!;
      });
    }));

    var placemarks = await placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude,
        localeIdentifier: "zh_TW");

    var sms = "";
    for (var item in reporList.entries) {
      if (placemarks.first.street
          .toString()
          .contains(item.key.substring(0, 3))) {
        sms = item.value;
      }
    }

    return [placemarks.first.street.toString().substring(5), sms];
  }
}
