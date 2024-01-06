import 'package:flutter/material.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';

class CustomImagePicker extends StatefulWidget {
  final List<String> imagePaths;

  const CustomImagePicker({super.key, required this.imagePaths});

  @override
  CustomImagePickerState createState() => CustomImagePickerState();
}

class CustomImagePickerState extends State<CustomImagePicker> {

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
      "Select an image",
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: widget.imagePaths.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context, widget.imagePaths[index]);
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.imagePaths[index]),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 110.0,
            mainAxisExtent: 110, // Maximum width of each item
            crossAxisSpacing: 8.0, // Space between columns
            mainAxisSpacing: 8.0, // Space between rows
          ),
        ),
      ),
    );
  }
}
