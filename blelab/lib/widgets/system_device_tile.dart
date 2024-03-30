import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class SystemDeviceTile extends StatefulWidget {
  final BluetoothDevice device;
  final VoidCallback onOpen;
  final VoidCallback onConnect;

  const SystemDeviceTile({
    required this.device,
    required this.onOpen,
    required this.onConnect,
    super.key,
  });

  @override
  State<SystemDeviceTile> createState() => _SystemDeviceTileState();
}

class _SystemDeviceTileState extends State<SystemDeviceTile> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription =
        widget.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }
  //  {advertisements: [{rssi: -88, manufacturer_data: {117: 4204018066700971a86a5f720971a86a5e010e0000000000}, remote_id: 70:09:71:A8:6A:5F, platform_name: [TV] Samsung TU7000 55 TV, service_data: {}}]}

  // {advertisements: [{rssi: -68, connectable: 1, manufacturer_data: {}, remote_id: 5C:FD:52:3B:59:F3, service_data: {fef3: 4a17234d58334711324c37f1c13543aa9badbfd5ac7e7a01c6bbb0}, service_uuids: [fef3]}]}

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.device.platformName),
      subtitle: Text(widget.device.remoteId.str),
      trailing: ElevatedButton(
        onPressed: isConnected ? widget.onOpen : widget.onConnect,
        child: isConnected ? const Text('OPEN') : const Text('CONNECT'),
      ),
    );
  }
}
