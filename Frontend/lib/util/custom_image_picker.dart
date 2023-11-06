import 'package:flutter/material.dart';
import 'package:ho_pla/util/ho_pla_scaffold.dart';

class CustomImagePicker extends StatefulWidget {
  final List<String> imagePaths; // List of asset paths to your images

  const CustomImagePicker({super.key, required this.imagePaths});

  @override
  CustomImagePickerState createState() => CustomImagePickerState();
}

class CustomImagePickerState extends State<CustomImagePicker> {
  String? selectedImage;

  @override
  Widget build(BuildContext context) {
    return HoPlaScaffold(
      "Select an image",
      Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Container(
            height: 100,
            child: ListView.builder(
              itemCount: widget.imagePaths.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImage = widget.imagePaths[index];
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.imagePaths[index]),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: selectedImage == widget.imagePaths[index]
                            ? Colors.blue
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (selectedImage != null)
            Image.asset(
              selectedImage!,
              width: 200,
              height: 200,
            ),
        ],
      ),
    );
  }
}
