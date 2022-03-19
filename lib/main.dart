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
    var reportList = Provider.of<ReportVM>(context).reportList;
    var address = Provider.of<ReportVM>(context).address;
    var sms = Provider.of<ReportVM>(context).sms;
    var plateController = Provider.of<ReportVM>(context).plateController;
    var smsController = Provider.of<ReportVM>(context).smsController;
    var rowHeight = MediaQuery.of(context).size.height / 12;
    var contentStyle = TextStyle(fontSize: rowHeight / 3);
    var titleStyle = TextStyle(fontSize: rowHeight / 2);

    Provider.of<ReportVM>(context).contentStyle = contentStyle;
    Provider.of<ReportVM>(context).titleStyle = titleStyle;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: rowHeight,
        title: Text(
          "檢舉魔人-簡訊版",
          style: titleStyle,
        ),
        actions: [
          SizedBox(
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        AlertDialog(
                          title: Text(
                            "檢舉魔人-簡訊版",
                            style: titleStyle,
                          ),
                          content: SizedBox(
                            height: rowHeight * 3,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "作者: OrzOGC",
                                    style: contentStyle,
                                  ),
                                  SizedBox(
                                    height: rowHeight / 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "寫糞code動機:",
                                        style: contentStyle,
                                      ),
                                      SizedBox(
                                        height: rowHeight / 8,
                                      ),
                                      Text(
                                        "讓我們來濫用保貴的警政資源當地下巿長, 一起來互相傷害吧!",
                                        style: contentStyle,
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        ),
                        Positioned(
                            top: rowHeight * 3,
                            right: MediaQuery.of(context).size.width / 12,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.close,
                                size: rowHeight / 2,
                              ),
                            )),
                      ],
                    );
                  },
                );
              },
              child: Text(
                "about",
                style: contentStyle,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ConstrainedBox(
                constraints: BoxConstraints.expand(height: rowHeight),
                child: Row(children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        "車牌:",
                        style: contentStyle,
                      )),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      style: contentStyle,
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
                        style: contentStyle,
                      )),
                  Expanded(
                    flex: 2,
                    child: DropdownButton(
                        itemHeight: rowHeight,
                        iconSize: rowHeight,
                        style: contentStyle,
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
                        style: contentStyle,
                      )),
                  Expanded(
                    flex: 3,
                    child: Text(
                      address,
                      style: contentStyle,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.gps_not_fixed),
                    iconSize: rowHeight / 2,
                    onPressed: () {
                      Provider.of<ReportVM>(context, listen: false)
                          .getAddress(context);
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ConstrainedBox(
              constraints: BoxConstraints.expand(height: rowHeight),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        "簡訊號碼:",
                        style: contentStyle,
                      )),
                  Expanded(
                      flex: 2,
                      child: Text(
                        sms,
                        style: contentStyle,
                      )),
                ],
              ),
            ),
            const Divider(),
            ConstrainedBox(
              constraints: BoxConstraints.expand(height: rowHeight * 3),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "檢舉內容:",
                      style: contentStyle,
                    ),
                    TextField(
                      maxLines: 6,
                      style: contentStyle,
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
                    child: IconButton(
                      icon: const Icon(Icons.cleaning_services),
                      iconSize: rowHeight / 2,
                      onPressed: () {
                        Provider.of<ReportVM>(context, listen: false).clear();
                      },
                    ),
                  ),
                ),
                const Spacer(),
                Expanded(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: rowHeight),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      iconSize: rowHeight / 2,
                      onPressed: sendable
                          ? () => Provider.of<ReportVM>(context, listen: false)
                              .sendingSMS()
                          : null,
                    ),
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
