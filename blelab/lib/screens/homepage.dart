import 'package:flutter/material.dart';
import 'package:blelab/services/appservices.dart';
import 'package:get/get.dart';
import 'package:blelab/utils/app_constants.dart';
import 'package:blelab/widgets/mainframe.dart';

import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../widgets/system_device_tile.dart';
import '../widgets/scan_result_tile.dart';

import '../utils/extra.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appservice = AppService();
  bool _isScanning = false;
  int sysdeviceCount = 0;
  int connectableCount = 0;

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  List<BluetoothDevice> _systemDevices = [];
  List<BluetoothDevice> tempsysdevices = [];
  List<ScanResult> _scanResults = [];
  List<ScanResult> tempscanResults = [];
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    init();
    refresh();
    firescanner();
    super.initState();
  }

  @override
  dispose() {
    _adapterStateStateSubscription.cancel();
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    sysdeviceCount = 0;
    connectableCount = 0;
    tempsysdevices = [];
    super.dispose();
  }

  init() {
    _systemDevices = [];
    _scanResults = [];
    tempsysdevices = [];
    sysdeviceCount = 0;
    connectableCount = 0;
  }

  refresh() {
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  firescanner() async {
    Future.delayed(const Duration(milliseconds: 500), () {
      scannerSwitcher();
    });
  }

  initScanner() {
    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {
          sysdeviceCount = _scanResults.length;
        });
      }
    }, onError: (e) {
      appservice.toastmessage("Scan Error: $e", isError: true);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  scannerSwitcher() async {
    setState(() {
      _isScanning = !_isScanning;
    });
    int v = -1;
    switch (_adapterState) {
      case BluetoothAdapterState.on:
        v = 1;
        break;
      case BluetoothAdapterState.off:
        v = 2;
        break;
      case BluetoothAdapterState.turningOff:
        v = 3;
        break;
      case BluetoothAdapterState.turningOn:
        v = 4;
        break;
      case BluetoothAdapterState.unauthorized:
        v = 5;
        break;
      case BluetoothAdapterState.unavailable:
        v = 6;
        break;
      case BluetoothAdapterState.unknown:
        v = 7;
        break;
      default:
        v = 8;
        break;
    }
    if (v == 1) {
      if (_isScanning) {
        initScanner();
        await onScanPressed();
      } else {
        await onStopPressed();
      }
    }
  }

  Future onScanPressed() async {
    //_systemDevices.clear();
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
    } catch (e) {
      appservice.toastmessage("System Devices Error: $e", isError: true);
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      appservice.toastmessage("Start Scan Error: $e", isError: true);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      appservice.toastmessage("Stop Scan Error:: $e", isError: true);
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connectAndUpdateStream().catchError((e) {
      appservice.toastmessage("Connect Error:: $e", isError: true);
    });
    Get.toNamed(AppConstants.connecteddevicepage,
        arguments: {'device': device});
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(const Duration(milliseconds: 1000));
  }

  //
  List<Widget> _buildSystemDeviceTiles(BuildContext context) {
    return _systemDevices
        .map(
          (d) => SystemDeviceTile(
            device: d,
            onOpen: () => Get.toNamed(AppConstants.connecteddevicepage,
                arguments: {'device': d}),
            onConnect: () => onConnectPressed(d),
          ),
        )
        .toList();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    tempscanResults = _scanResults;
    tempscanResults.sort((a, b) {
      // Sort based on connectable
      if (a.advertisementData.connectable && !b.advertisementData.connectable) {
        return -1;
      } else if (!a.advertisementData.connectable &&
          b.advertisementData.connectable) {
        return 1;
      } else {
        // If both connectable states are the same, sort based on absolute value of rssi
        final int rssiA = a.rssi.abs();
        final int rssiB = b.rssi.abs();

        // Sort based on RSSI values
        if (a.advertisementData.connectable) {
          // For connectable items, prioritize higher RSSI values (closer to 0)
          return rssiA.compareTo(rssiB);
        } else {
          // For non-connectable items, prioritize lower RSSI values (farther from 0)
          return rssiB.compareTo(rssiA);
        }
      }
    });
    connectableCount = 0;
    for (var result in tempscanResults) {
      if (result.advertisementData.connectable) {
        connectableCount++;
      }
    }
    setState(() {});

    return tempscanResults
        .map(
          (r) => ScanResultTile(
            result: r,
            onTap: () => onConnectPressed(r.device),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainPageFrame(
      pageindex: 0,
      appbarwidget: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          leadingWidth: 100,
          titleSpacing: 5,
          title: _isScanning
              ? Text('Scanning... $sysdeviceCount')
              : sysdeviceCount > 0
                  ? Text('Connectable: $connectableCount/$sysdeviceCount')
                  : const Text('Scan'),
          actions: [
            IconButton(
              icon: _isScanning && (sysdeviceCount % 2 == 1)
                  ? const Icon(Icons.stop_circle,
                      color: Colors.orange, size: 35)
                  : _isScanning
                      ? const Icon(Icons.stop_circle,
                          color: Color.fromARGB(255, 213, 151, 70), size: 35)
                      : const Icon(Icons.wifi_find,
                          color: Colors.green, size: 35),
              onPressed: () async {
                await scannerSwitcher();
              },
            )
          ]),
      subwidget: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: <Widget>[
            ..._buildSystemDeviceTiles(context),
            ..._buildScanResultTiles(context),
          ],
        ),
      ),
    );
  }
}
