import 'package:flutter/material.dart';
import 'package:blelab/services/appservices.dart';
import 'package:blelab/utils/app_constants.dart';
import 'package:blelab/widgets/mainframe.dart';

class AccounttHomePage extends StatefulWidget {
  const AccounttHomePage({super.key});
  @override
  State<AccounttHomePage> createState() => _AccounttHomePageState();
}

class _AccounttHomePageState extends State<AccounttHomePage> {
  final appservice = AppService();
  String username = "";
  Map<int, String> accountItemsMap = {
    0: "App Information",
    1: "About BLE",
    2: "Next Release",
  };
  int _currentExpandedPanelIndex = -1;

  @override
  void initState() {
    _currentExpandedPanelIndex = -1;
    super.initState();
    load();
  }

  load() async {
    setState(() {});
  }

  Widget getScrollWidget() {
    return SingleChildScrollView(
      child: Column(
        // used to be "Stack"
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ListTile(
            leading: Icon(Icons.email, color: Colors.blue),
            title: Text("Hi Blelab User",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                )),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20.0, left: 25.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: const Color(0xFFE6E6E6)),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: const SizedBox(
                height: 200,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainPageFrame(
      pageindex: 2,
      appbarwidget: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        //leadingWidth: 16,
        titleSpacing: 16,
        title: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About",
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
      subwidget: ListView.builder(
        itemCount: accountItemsMap.length,
        itemBuilder: (context, index) {
          String title = accountItemsMap[index]!;
          return CardItem(
              index: index,
              title: title,
              isExpanded:
                  _currentExpandedPanelIndex == index, // Expand by default
              currentExpandedPanelIndex: _currentExpandedPanelIndex);
        },
      ),
      marginpading: 1,
    );
  }
}

class CardItem extends StatefulWidget {
  String title;
  bool isExpanded;
  int index;
  int currentExpandedPanelIndex;
  @override
  CardItem(
      {super.key,
      required this.index,
      required this.title,
      required this.isExpanded,
      required this.currentExpandedPanelIndex});
  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  final appservice = AppService();
  bool notificationEnabled = true;
  List<IconData> accountItemLeadingIcons = [
    Icons.info,
    Icons.bluetooth,
    Icons.list,
  ];
  List<Color> accountItemLeadingIconsBkColors = [
    Colors.blue,
    Colors.blue,
    Colors.blue,
    Colors.blue,
    Colors.blue,
    Colors.blue,
  ];

  @override
  void initState() {
    load();
    super.initState();
  }

  load() {
    notificationEnabled = true;
    setState(() {});
  }

  Widget getTitleText(String v,
      {bool isTitle = false, bool isTestVerion = false}) {
    if (isTitle) {
      return Text(v,
          style: TextStyle(
            fontSize: 21,
            color: isTestVerion
                ? const Color.fromARGB(255, 250, 4, 4)
                : const Color.fromARGB(255, 97, 97, 97),
          ));
    } else {
      return Text(v,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ));
    }
  }

  showSnackBarmessage(String msg) {
    appservice.toastmessageType(msg, msgtype: 1, durationms: 380);
  }

  List<Widget> buildDetailsWidgets(int accountindex) {
    if (accountindex == 0) {
      return [
        const SizedBox(
          height: 8,
        ),
        getTitleText("APP Name", isTitle: true),
        getTitleText("BLElab", isTitle: false),
        const SizedBox(
          height: 8,
        ),
        const SizedBox(
          height: 8,
        ),
        getTitleText("Build date", isTitle: true),
        getTitleText("2024-04-05", isTitle: false),
        const SizedBox(
          height: 8,
        ),
        const SizedBox(
          height: 8,
        ),
        getTitleText("Version", isTitle: true),
        getTitleText(AppConstants.appVersion, isTitle: false),
        const SizedBox(
          height: 8,
        ),
        const SizedBox(
          height: 8,
        ),
      ];
    } else if (accountindex == 1) {
      return [
        const SizedBox(
          height: 8,
        ),
        getTitleText("BLE", isTitle: true),
        getTitleText(
            "Bluetooth Low Energy is a wireless personal area network technology designed and marketed by the Bluetooth Special Interest Group aimed at novel applications in the healthcare, fitness, beacons, security, and home entertainment industries",
            isTitle: false),
        const SizedBox(
          height: 8,
        ),
      ];
    } else if (accountindex == 2) {
      return [
        const SizedBox(
          height: 8,
        ),
        getTitleText("Features", isTitle: true),
        getTitleText("BLE Peripheral", isTitle: false),
        const SizedBox(
          height: 8,
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isExpanded = !widget.isExpanded;
        });
      },
      child: ExpansionPanelList(
        elevation: 2,
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            widget.isExpanded = !widget.isExpanded;
            if (widget.isExpanded) {
              widget.currentExpandedPanelIndex = widget.index;
            }
          });
        },
        children: [
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                leading: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    accountItemLeadingIconsBkColors[widget.index],
                    BlendMode.srcATop,
                  ),
                  child: Icon(
                    accountItemLeadingIcons[widget.index],
                    size: 28,
                  ),
                ),
                title: Text(widget.title,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                trailing: null,
              );
            },
            body: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 243, 243),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: buildDetailsWidgets(widget.index),
                      )),
                )),
            isExpanded: widget.isExpanded,
          ),
        ],
      ),
    );
  }
}
