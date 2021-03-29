
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File _imageFile;
  final picker = ImagePicker();

  Future<void> _saveImage() async {
    if (_imageFile != null) {
      print('-----------------------------------');
      print(_imageFile.path);
      Future result = await ImageGallerySaver.saveFile(_imageFile.path);
      print(result);
    }

  }

  Future<void> _pickImage(ImageSource source) async {
    final selected = await picker.getImage(source: source);
    setState(() {
      if (selected != null) {
        _imageFile = File(selected.path);
      }
    });
  }

  Future<void> _crop(ImageSource source) async {
    final selected = await picker.getImage(source: source);
    if (selected != null) {
      File cropped = await ImageCropper.cropImage(
        sourcePath: selected.path,
        compressQuality: 100,
        aspectRatio: CropAspectRatio(
            ratioX: 1,
            ratioY: 1),
        maxWidth: 1000,
        maxHeight: 1000,
        compressFormat: ImageCompressFormat.jpg,
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarTitle: "Crop",
          statusBarColor: Colors.deepOrange.shade900,
          backgroundColor: Colors.white
        )
      );
      setState(() {
        _imageFile = cropped;
      });
    }
  }
  // _imageFile == null ? Text('No Image Selected') : Image.file(_imageFile),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Pictures'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Container(
              width: 300.0,
              height: 400.0,
                child: _imageFile == null ? Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('No Image Selected'),
                  ),
                  color:   Color(0xFF939BB1),
                ) : FittedBox(
                  child: Image.file(_imageFile),
                  fit: BoxFit.fill,
                )
            ),
            SizedBox(
              height: 30.0
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 70.0,
                  child: ElevatedButton(
                      onPressed: () {
                        _crop(ImageSource.gallery);
                      },
                      child: Icon(Icons.crop)
                  ),
                ),
                SizedBox(
                  width: 70.0,
                  child: ElevatedButton(
                    onPressed: () {
                      _saveImage();
                    },
                    child: Icon(Icons.save_alt),
                  ),
                )
              ],
            )
          ],
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
