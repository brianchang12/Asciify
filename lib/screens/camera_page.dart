
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File _imageFile;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final selected = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (selected != null) {
        _imageFile = File(selected.path);
      } else {
        final noImage = SnackBar(content: Text('No Image Selected'));
        ScaffoldMessenger.of(context).showSnackBar(noImage);
      }
    });
  }
  // _imageFile == null ? Text('No Image Selected') : Image.file(_imageFile),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 200.0,
          height: 200.0,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            ),
            child: _imageFile == null ? Text('No Image Selected') : Image.file(_imageFile),
          )
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pickImage(ImageSource.camera);
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
