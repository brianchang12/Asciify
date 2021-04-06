
import 'dart:io';
import 'dart:typed_data';
import 'package:asciify/screens/custom_exception.dart';
import 'package:asciify/screens/home_page.dart';
import 'package:dio/dio.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' as io;

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File _imageFile;
  final picker = ImagePicker();




  Future<void> _saveImage(String fileName) async {
    if (_imageFile != null) {
      if (Platform.isAndroid) {
        Directory directory = await getExternalStorageDirectory();
        String directoryPath = directory.path;
        String filePath = '$directoryPath/$fileName.jpg';
        if (await File(filePath).exists()) {
          throw SameNameFileException('File with Same Name Found');
        }
        File saveFile = File(filePath);
        await saveFile.writeAsBytes(await _imageFile.readAsBytes());
        final saved = SnackBar(content: Text('Saved'));
        ScaffoldMessenger.of(context).showSnackBar(saved);
        print(_imageFile.path);
        print(saveFile.path);
      } else {
        throw PlatformException('Platform is not Supported');
      }
    }  else {
      throw NoImageException('No Image is Selected');
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
      resizeToAvoidBottomInset: false,
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
                      showDialog(context: context,
                          builder: (BuildContext context) {
                            TextEditingController textController = TextEditingController();
                            String exceptionText = '';
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: Text('Please Add a Name to your File'),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(exceptionText,
                                      style: TextStyle(
                                          color: Colors.red
                                      ),
                                    ),
                                    TextField(
                                      controller: textController,
                                      decoration: InputDecoration(
                                          hintText: 'Name'
                                      ),
                                    ),
                                  ]
                              ),
                              actions: [
                                ElevatedButton(onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                    child: Icon(Icons.cancel)),
                                ElevatedButton(onPressed: () async {
                                  try {
                                    await _saveImage(textController.text);
                                  } catch(e) {
                                    print('goodbye');
                                    if (e is SameNameFileException ||
                                        e is NoImageException || e is PlatformException) {
                                      print('hello');
                                      setState(() {
                                        print(e.cause);
                                        exceptionText = e.cause;
                                      });
                                    } else {
                                      print(e.toString());
                                    }

                                  }
                                },
                                    child: Icon(Icons.check))
                              ],
                            );
                          }
                        );
                      });
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
