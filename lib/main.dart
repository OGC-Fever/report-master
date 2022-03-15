import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:report_master/vm.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ReportVM(),
      child: const ReportDevil(),
    ),
  );
}

class ReportDevil extends StatelessWidget {
  const ReportDevil({Key? key}) : super(key: key);

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
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  var chooseValue = "併排停車";

  @override
  Widget build(BuildContext context) {
    var sendable = Provider.of<ReportVM>(context).sendable;
    var cus = const TextStyle(fontSize: 18);
    var reportList = Provider.of<ReportVM>(context).reportList;
    Provider.of<ReportVM>(context).chooseValue = chooseValue;
    var address = Provider.of<ReportVM>(context).address;
    var sms = Provider.of<ReportVM>(context).sms;
    var plateController = Provider.of<ReportVM>(context).plateController;
    var smsController = Provider.of<ReportVM>(context).smsController;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report Devil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  child: Row(children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "車牌:",
                      style: cus,
                    )),
                Expanded(
                  flex: 2,
                  child: TextField(
                    style: cus,
                    controller: plateController,
                    onChanged: (value) {
                      Provider.of<ReportVM>(context, listen: false).renew();
                    },
                  ),
                ),
              ])),
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          "檢舉項目:",
                          style: cus,
                        )),
                    Expanded(
                      flex: 2,
                      child: DropdownButton(
                          style: cus,
                          value: chooseValue,
                          items: reportList.toList(),
                          onChanged: (value) {
                            setState(() {
                              chooseValue = value.toString();
                            });
                            Provider.of<ReportVM>(context, listen: false)
                                .chooseValue = value.toString();
                            Provider.of<ReportVM>(context, listen: false).renew();
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          "Address:",
                          style: cus,
                        )),
                    Expanded(
                      flex: 2,
                      child: Text(
                        address,
                        style: cus,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Provider.of<ReportVM>(context, listen: false)
                              .getAddress();
                        },
                        child: const Icon(Icons.gps_not_fixed))
                  ],
                ),
              ),
              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          "SMS:",
                          style: cus,
                        )),
                    Expanded(
                        flex: 2,
                        child: Text(
                          sms,
                          style: cus,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 150,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Report Message:",
                        style: cus,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    TextField(
                      maxLines: null,
                      style: cus,
                      controller: smsController,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {
                          Provider.of<ReportVM>(context, listen: false).clear();
                        },
                        child: const Icon(Icons.cleaning_services)),
                  ),
                  const Spacer(),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: sendable
                            ? () => Provider.of<ReportVM>(context, listen: false)
                                .sendingSMS()
                            : null,
                        child: const Icon(Icons.send)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
