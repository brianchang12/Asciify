import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:asciify/screens/custom_exception.dart';
import 'package:asciify/screens/home_page.dart';
import 'package:dio/dio.dart';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';



class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File _imageFile;
  final picker = ImagePicker();
  Image image;
  TextEditingController textController = TextEditingController();




  Future<void> _saveImage({String fileName, String format, File fileToSave}) async {
    if (fileToSave != null) {
      if (Platform.isAndroid) {
        Directory directory = await getExternalStorageDirectory();
        String directoryPath = directory.path;
        String filePath = '$directoryPath/$fileName$format';
        if (await File(filePath).exists()) {
          throw SameNameFileException('File with Same Name Found, Please Rename');
        }
        File saveFile = File(filePath);
        await saveFile.writeAsBytes(await fileToSave.readAsBytes());
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

  StatefulBuilder _saveDialogue({String exceptionText = '', File fileToSave, String format}) {
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
                textController.clear();
                Navigator.of(context).pop();
              },
                  child: Icon(Icons.cancel)),
              ElevatedButton(onPressed: () async {
                try {
                  await _saveImage(fileName: textController.text, format: format,
                  fileToSave: fileToSave);
                  Navigator.of(context).pop();
                  SnackBar saveMessage = SnackBar(content: Text('Image Saved'));
                  ScaffoldMessenger.of(context).showSnackBar(saveMessage);
                } catch(e) {
                  if (e is SameNameFileException ||
                      e is NoImageException || e is PlatformException) {
                    setState(() {
                      exceptionText = e.cause;
                    });
                  } else {
                    print(e.toString());
                  }

                } finally {
                  textController.clear();
                }
              },
                  child: Icon(Icons.check))
            ],
          );
        }
    );
  }

  Future<File> _convertImage() async {
    if (_imageFile == null) {
      throw NoImageException('No Image to Convert');
    } else {
      img.Image test = img.decodeImage(await _imageFile.readAsBytes());
      int width = test.width;
      int height = test.height;
      double scaleFactor = 0.075;
      test = img.copyResize(
          test, height: (scaleFactor * height * (1.30)).toInt(),
          width: (scaleFactor * width).toInt(),
          interpolation: img.Interpolation.nearest);
      test = img.grayscale(test);
      test = img.adjustColor(test, contrast: 20.0);
      String chars = " .:-=+*#%@";
      List<String> charList = chars.split("");
      charList = charList.reversed.toList();
      int charLength = charList.length;
      double interval = charLength / 256;
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      File output = File('$path/output.txt');
      output.writeAsStringSync('');
      for (int y = 0; y < test.height; y++) {
        for (int x = 0; x < test.width; x++) {
          int testPixel = test.getPixel(x, y);
          int blue = ((testPixel & 0x00FF0000) >> 16);
          int green = ((testPixel & 0x0000FF00) >> 8);
          int red = testPixel & 0x000000FF;
          int grayValue = ((red / 3) + (green / 3) + (blue / 3)).round();
          await output.writeAsString(
              charList[(grayValue * interval).floor()], mode: FileMode.append);
        }
        await output.writeAsString('\n', mode: FileMode.append);
      }
      return output;
    }
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
            Container(
              margin: EdgeInsets.fromLTRB(0, 30.0, 0, 30.0),
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.60,
                child: _imageFile == null ? Card(
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
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return _saveDialogue(fileToSave: _imageFile, format: '.png');
                      });
                    },
                    child: Icon(Icons.save_alt),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            SizedBox(
              width: 150.0,
              child: ElevatedButton(
                onPressed: () async {
                  SnackBar message;
                  File converted;
                  bool conversionFailed = false;
                  BuildContext dialogContext;
                  showDialog(context: context, barrierDismissible: false,
                      builder: (BuildContext context) {
                        dialogContext = context;
                        return Dialog(
                          child: new Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              Text('Converting')
                            ],
                          ),
                        );
                      });
                  try {
                    converted = await _convertImage();
                    Navigator.pop(dialogContext);
                  } on NoImageException catch(e) {
                    Navigator.pop(dialogContext);
                    message = SnackBar(content: Text(e.cause));
                    ScaffoldMessenger.of(context).showSnackBar(message);
                    conversionFailed = true;
                  }
                  if (!conversionFailed) {
                    showDialog(context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return _saveDialogue(fileToSave: converted, format: '.txt');
                    });
                  }
                },
                child: Icon(Icons.alternate_email),
              ),
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
