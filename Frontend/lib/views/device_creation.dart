import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ho_pla/model/house_change_notifier.dart';
import 'package:ho_pla/model/item.dart';
import 'package:ho_pla/util/backend.dart';
import 'package:ho_pla/util/custom_image_picker.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';

class DeviceCreationWidget extends StatefulWidget {
  final HouseChangeNotifier notifier;

  const DeviceCreationWidget(this.notifier, {super.key});

  @override
  State<DeviceCreationWidget> createState() => _DeviceCreationWidgetState();
}

class _DeviceCreationWidgetState extends State<DeviceCreationWidget> {
  String imgPath = "assets/icons/washing-machine.png";
  TextEditingController nameController = TextEditingController();

  /// This is used to hide the hint after the user changed the image
  bool promptTapToChange = true;

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
      "Create new item",
      Center(
        child: ListView(
          padding: const EdgeInsets.all(60.0),
          children: [
            GestureDetector(
              onTap: onChangeIconClicked,
              child: Container(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image(image: AssetImage(imgPath), fit: BoxFit.fill),
                    if (promptTapToChange) const Text("Tap to change"),
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
    );
  }

  onChangeIconClicked() async {
    final imagePaths = await getImagesInAssets();

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
      promptTapToChange = false;
      imgPath = newImagePath;
    });
  }

  onSaveClicked() async {
    try {
      var res = await Backend.createDevice(
          nameController.text, widget.notifier.house.id.toString(), imgPath);

      if (res.statusCode == 201) {
        Item newDevice = jsonDecode(res.body);

        if (context.mounted) {
          // Return to device overview
          Navigator.pop(context, newDevice);
        }

        return;
      } else {
        showError('Could not create the device: status ${res.statusCode}');
      }
    } on Exception catch (e, _) {
      showError('Error creating the device');
    }
  }

  void showError(String message) {
    var snackBar = SnackBar(content: Text(message));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
