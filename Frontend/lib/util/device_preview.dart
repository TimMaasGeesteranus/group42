import 'package:flutter/material.dart';

class DevicePreviewWidget extends StatelessWidget {
  final AssetImage image;
  final String name;

  const DevicePreviewWidget(this.image, this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      color: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image(image: image, fit: BoxFit.fill),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(name),
          )
        ],
      ),
    );
  }
}
