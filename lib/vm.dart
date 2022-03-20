import 'dart:async';
import 'dart:io';

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
  Position? currentLocation;
  late bool gpsStatus;
  late bool internetStatus;
  var timeout = 3;
  var plateController = TextEditingController();
  var smsController = TextEditingController();
  var address = "";
  var sms = "";
  var sendable = false;
  late TextStyle contentStyle;
  late TextStyle titleStyle;

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

  Future<void> checkInternet() async {
    await InternetAddress.lookup("google.com").then((value) {
      if (value.isNotEmpty) {
        internetStatus = true;
      }
    }).catchError((error) {
      internetStatus = false;
    });
  }

  Future<void> checkGPS() async {
    await Geolocator.isLocationServiceEnabled().then((value) async {
      if (value == false) {
        await Geolocator.openLocationSettings();
      }
    });
    await Geolocator.checkPermission().then((value) async {
      if (value == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
    });
    await Geolocator.getCurrentPosition()
        .then((value) {
          currentLocation = value;
          gpsStatus = true;
        })
        .timeout(Duration(seconds: timeout))
        .catchError((error) async {
          gpsStatus = false;
          currentLocation = await Geolocator.getLastKnownPosition();
        });
  }

  Future<void> getAddress(context) async {
    getData(context).then((value) {
      if (value != null) {
        address = value[0];
        sms = value[1];
      }
      renew();
    });
  }

  Future<List?> getData(context) async {
    await checkInternet();
    if (!internetStatus) {
      msgBox(context, "無網路連線", null, false);
      Timer(Duration(seconds: timeout), () => Navigator.pop(context));
      return null;
    }
    msgBox(context, "資料讀取中...", null, false);
    await checkGPS();
    Navigator.pop(context);
    if (!gpsStatus) {
      msgBox(
          context, "無GPS訊號", Text("讀取最近一次的定位地址", style: contentStyle), false);
      Timer(Duration(seconds: timeout), () => Navigator.pop(context));
    }
    var placemarks = await placemarkFromCoordinates(
            currentLocation!.latitude, currentLocation!.longitude,
            localeIdentifier: "zh_TW")
        .catchError((error) {
      msgBox(context, "網路連線異常", null, true);
    });

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

  Future msgBox(context, title, widget, dismiss) {
    return showDialog(
      context: context,
      barrierDismissible: dismiss,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text(title, style: titleStyle),
          content: widget,
        );
      },
    );
  }

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

  Future<void> sendingSMS() async {
    await sendSMS(message: smsController.text, recipients: [sms]);
    sendable = false;
    notifyListeners();
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
}
