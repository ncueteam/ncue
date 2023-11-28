import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:ncue.aiot_app/src/features/bluetooth/Tiles/descriptor_tile.dart';

class CharacteristicTile extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final Future<void> Function()? onReadPressed;
  final Future<void> Function()? onWritePressed;
  final Future<void> Function()? onNotificationPressed;

  const CharacteristicTile(
      {Key? key,
      required this.characteristic,
      required this.descriptorTiles,
      this.onReadPressed,
      this.onWritePressed,
      this.onNotificationPressed})
      : super(key: key);

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: widget.characteristic.onValueReceived,
      initialData: widget.characteristic.lastValue,
      builder: (context, snapshot) {
        // final List<int>? value = snapshot.data;
        //if (widget.characteristic.characteristicUuid.toString().toUpperCase() ==
        //characteristicuuid) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const Text('Characteristic'),
            // Text(
            //   '0x${widget.characteristic.characteristicUuid.toString().toUpperCase()}',
            //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            //       color: Theme.of(context).textTheme.bodySmall?.color),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.characteristic.properties.write)
                  ElevatedButton(
                      child: Text(
                          widget.characteristic.properties.writeWithoutResponse
                              ? "WriteNoResp"
                              : "Submit"),
                      onPressed: () async {
                        await widget.onWritePressed!();
                        setState(() {});
                      }),
              ],
            )
          ],
        );
        //} else {
        //return const SizedBox.shrink();
        //}
      },
    );
  }
}
