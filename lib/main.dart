import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:report_master/vm.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      ChangeNotifierProvider(
        create: (context) => ReportVM(),
        child: const ReportDevil(),
      ),
    );
  });
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
  @override
  Widget build(BuildContext context) {
    var chooseValue = Provider.of<ReportVM>(context).chooseValue;
    var sendable = Provider.of<ReportVM>(context).sendable;
    var customStyle = const TextStyle(fontSize: 18);
    var reportList = Provider.of<ReportVM>(context).reportList;
    var address = Provider.of<ReportVM>(context).address;
    var sms = Provider.of<ReportVM>(context).sms;
    var plateController = Provider.of<ReportVM>(context).plateController;
    var smsController = Provider.of<ReportVM>(context).smsController;
    var rowHeight = MediaQuery.of(context).size.height / 11;

    return Scaffold(
      appBar: AppBar(
        title: const Text("檢舉魔人-簡訊版"),
        actions: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("檢舉魔人-簡訊版"),
                    content: ConstrainedBox(
                      constraints: BoxConstraints.expand(
                          height: MediaQuery.of(context).size.height / 2),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Expanded(flex: 1, child: Text("作者:")),
                                Expanded(flex: 3, child: Text("OrzOGC")),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: const [
                                Text(
                                  "寫糞code動機:",
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Text(
                              "既然條子們嫌坐在辦公室吹冷氣辦案太累, 我只好大發慈悲的請他們多出門走走,多運動有益身心健康, 違規魔人一個比一個誇張無恥毫無下限, 反正檢舉不用錢,就讓我們來濫用保貴的警政資源當地下巿長, 一起來互相傷害吧!",
                            ),
                          ]),
                    ),
                  );
                },
              );
            },
            child: const Text("about"),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ConstrainedBox(
                constraints: BoxConstraints.expand(height: rowHeight),
                // height: rowHeight,
                child: Row(children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        "車牌:",
                        style: customStyle,
                      )),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      style: customStyle,
                      controller: plateController,
                      onChanged: (value) {
                        Provider.of<ReportVM>(context, listen: false).renew();
                      },
                    ),
                  ),
                ])),
            ConstrainedBox(
              constraints: BoxConstraints.expand(height: rowHeight),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        "檢舉項目:",
                        style: customStyle,
                      )),
                  Expanded(
                    flex: 2,
                    child: DropdownButton(
                        style: customStyle,
                        value: chooseValue,
                        items: reportList.toList(),
                        onChanged: (value) {
                          Provider.of<ReportVM>(context, listen: false)
                              .chooseValue = value.toString();
                          Provider.of<ReportVM>(context, listen: false).renew();
                        }),
                  ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.expand(height: rowHeight * 2),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        "地址:",
                        style: customStyle,
                      )),
                  Expanded(
                    flex: 2,
                    child: Text(
                      address,
                      style: customStyle,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Provider.of<ReportVM>(context, listen: false)
                          .getAddress(context);
                    },
                    child: const Icon(
                      Icons.gps_not_fixed,
                    ),
                  )
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.expand(height: rowHeight),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        "簡訊號碼:",
                        style: customStyle,
                      )),
                  Expanded(
                      flex: 2,
                      child: Text(
                        sms,
                        style: customStyle,
                      )),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.expand(height: rowHeight * 3),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "檢舉內容:",
                      style: customStyle,
                    ),
                    TextField(
                      maxLines: null,
                      style: customStyle,
                      controller: smsController,
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: rowHeight),
                    child: ElevatedButton(
                        onPressed: () {
                          Provider.of<ReportVM>(context, listen: false).clear();
                        },
                        child: const Icon(Icons.cleaning_services)),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: rowHeight),
                    child: ElevatedButton(
                        onPressed: sendable
                            ? () =>
                                Provider.of<ReportVM>(context, listen: false)
                                    .sendingSMS()
                            : null,
                        child: const Icon(Icons.send)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
