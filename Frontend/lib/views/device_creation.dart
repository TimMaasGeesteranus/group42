import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ho_pla/model/house.dart';
import 'package:ho_pla/model/item.dart';
import 'package:ho_pla/util/custom_image_picker.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';

class DeviceCreationWidget extends StatefulWidget {
  final House house;

  const DeviceCreationWidget(this.house, {super.key});

  @override
  State<DeviceCreationWidget> createState() => _DeviceCreationWidgetState();
}

class _DeviceCreationWidgetState extends State<DeviceCreationWidget> {
  AssetImage img = AssetImage("assets/icons/washing-machine.png");
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
      "Create new item",
      Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onChangeIconClicked,
                child: Container(
                  width: 200,
                  height: 200,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Image(image: img, fit: BoxFit.fill),
                      const Text("Tap to change"),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Device name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              TextButton(onPressed: onSaveClicked, child: const Text("Save"))
            ],
          ),
        ),
      ),
    );
  }

  onChangeIconClicked() async {
    final imagePaths = await getImagesInAssets();
    debugPrint(imagePaths.toString());

    // Needed because of build context async gap
    if (!mounted) return;

    // Let the user pick a new image
    final String newImagePath =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CustomImagePicker(
        imagePaths: imagePaths,
      );
    }));

    if (!mounted) return;

    // Replace the image with the newly selected
    setState(() {
      img = AssetImage(newImagePath);
    });
  }

  onSaveClicked() {
    // TODO: adjust id
    Item device = Item(
        id: 0,
        name: nameController.text,
        house: widget.house,
        reservations: []);

    // TODO: send request to create item
    Navigator.pop(context, device);
  }

  // https://stackoverflow.com/questions/56544200/flutter-how-to-get-a-list-of-names-of-all-images-in-assets-directory
  Future<List<String>> getImagesInAssets() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    return manifestMap.keys
        .where((String key) => key.contains('/icons/'))
        .toList();
  }
}