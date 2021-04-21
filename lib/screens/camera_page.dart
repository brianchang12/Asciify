
import 'dart:io';
import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:asciify/class/asciiConverter.dart';
import 'package:asciify/exception/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';



class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _imageFile;
  final picker = ImagePicker();
  Image? image;
  late TextEditingController textController;


  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }


  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> _saveImage({required String fileName,
    required String format,
    File? fileToSave, StringBuffer? buffer}) async {
    Directory? directory;
    if (Platform.isAndroid) {
       directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    }
    String directoryPath = directory!.path;
    String filePath = '$directoryPath/$fileName$format';
    if (await File(filePath).exists()) {
      throw SameNameFileException('File with Same Name Found, Please Rename');
    }
    File saveFile = File(filePath);
    if (fileToSave != null && buffer == null) {
      await saveFile.writeAsBytes(await fileToSave.readAsBytes());
    } else if (fileToSave == null && buffer != null) {
      await saveFile.writeAsString(buffer.toString());
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

  StatefulBuilder _saveDialog({File? fileToSave, StringBuffer? buffer, required String format}) {
    String exceptionText = '';
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          print(context);
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: AlertDialog(
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
                    fileToSave: fileToSave, buffer: buffer);
                    Navigator.of(context).pop();
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      duration: Duration(seconds: 2),
                      message: 'Image Saved',
                      isDismissible: true,
                      flushbarStyle: FlushbarStyle.FLOATING,
                    )..show(context);
                  } on SameNameFileException catch(e) {
                    setState(() {
                      exceptionText = e.getCause();
                    });
                  } catch(e) {
                    print(e.toString());
                  } finally {
                    textController.clear();
                  }
                },
                    child: Icon(Icons.check))
              ],
            ),
          );
        }
    );
  }

  Future<StringBuffer> _convertImage(Orientation orientation) async {
    if (_imageFile == null) {
      throw NoImageException('No Image to Convert');
    } else {
      late double widthFactor;
      if (orientation == Orientation.portrait) {
        widthFactor = 1.12;
      } else {
        widthFactor = 3.12;
      }
      img.Image imageExtract = img.decodeImage(await _imageFile!.readAsBytes())!;
      int width = imageExtract.width;
      int height = imageExtract.height;
      double scaleFactor = 0.075;
      imageExtract = img.copyResize(imageExtract, height: (scaleFactor * height).toInt(),
          width: (scaleFactor * width * widthFactor).toInt(),
          interpolation: img.Interpolation.nearest);
      imageExtract = img.adjustColor(imageExtract, contrast: 20.0);
      var asciiConverter = AsciiConverter.getInstance();
      var buffer = asciiConverter!.asciiConvert(imageExtract);
      return buffer;
    }
  }



  Future<void> _crop(Orientation orientation) async {
    if (_imageFile == null) {
      throw NoImageException("No Image to Crop");
    } else {
      late double y;
      late double x;
      if (orientation == Orientation.portrait) {
        y = 1;
        x = MediaQuery.of(context).size.aspectRatio;
      } else {
        y = MediaQuery.of(context).size.aspectRatio;
        x = 1;
      }
      File? cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile!.path,
        // compressQuality: 100,
        // aspectRatio: CropAspectRatio(
        //     ratioX: x,
        //     ratioY: y),
        // maxWidth: 2000,
        // maxHeight: 1000,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
        compressFormat: ImageCompressFormat.png,
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ),
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.deepOrange,
          toolbarTitle: "Crop",
          statusBarColor: Colors.deepOrange.shade900,
          backgroundColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
        )
      );
      setState(() {
        _imageFile = cropped;
      });
    }
  }

  Widget _cropButton(Orientation orientation) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.27,
      child: ElevatedButton(
        key: Key('cropButton'),
          onPressed: () async {
            try {
              await _crop(orientation);
            } on NoImageException catch(e) {
              Flushbar(
                flushbarPosition: FlushbarPosition.TOP,
                duration: Duration(seconds: 2),
                message: e.getCause(),
                isDismissible: true,
                flushbarStyle: FlushbarStyle.FLOATING,
              )..show(context);
            }
          },
          child: Icon(Icons.crop)
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.27,
      child: ElevatedButton(
        key: Key('saveButton'),
        onPressed: () {
          if (_imageFile == null) {
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              duration: Duration(seconds: 2),
              message: 'No Image to Save',
              isDismissible: true,
              flushbarStyle: FlushbarStyle.FLOATING,
            )..show(context);
          } else {
            showDialog(context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return _saveDialog(fileToSave: _imageFile, format: '.png');
                });
          }
        },
        child: Icon(Icons.save_alt),
      ),
    );
  }

  Widget _imageDisplay() {
    return _imageFile == null
        ? Card(
            key: Key('emptyImageDisplay'),
            child: Center(
              child: Text('No Image Selected'),
            ),
            color: Color(0xFF939BB1),
          )
        : FittedBox(
            key: Key('imageDisplay'),
            child: Image.file(_imageFile!),
            fit: BoxFit.fill,
          );
  }

  // _imageFile == null ? Text('No Image Selected') : Image.file(_imageFile),
  Widget _landscapeOrientation(Orientation orientation) {
    Orientation orientation = Orientation.landscape;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 7,
            child: Container(
              margin: EdgeInsets.only(left: 7.0),
                width: MediaQuery.of(context).size.width * 0.60,
                height: MediaQuery.of(context).size.height * 0.60,
                child: _imageDisplay()
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                _cropButton(orientation),
                _saveButton(),
                _convertButton(orientation),
                _cameraButton(),
              ],
            ),
          ),
        ],
      );
  }

  Widget _convertButton(Orientation orientation) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.27,
      child: ElevatedButton(
        key: Key('convertButton'),
        onPressed: () async {
          late StringBuffer converted;
          bool conversionFailed = false;
          showDialog(context: context, barrierDismissible: false,
              builder: (BuildContext context) {
                context.findAncestorRenderObjectOfType();
                return Dialog(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: CircularProgressIndicator(),
                        margin: EdgeInsets.all(15.0),
                      ),
                      Container(
                        child: Text('Converting'),
                        margin: EdgeInsets.all(15.0),
                      )
                    ],
                  ),
                );
              });
          try {
            converted = await _convertImage(orientation);
            Navigator.pop(context);
          } on NoImageException catch(e) {
            Navigator.pop(context);
            Flushbar(
              flushbarPosition: FlushbarPosition.TOP,
              duration: Duration(seconds: 2),
              message: e.getCause(),
              isDismissible: true,
              flushbarStyle: FlushbarStyle.FLOATING,
            )..show(context);
            conversionFailed = true;
          }
          if (!conversionFailed) {
            showDialog(context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return _saveDialog(buffer: converted, format: '.txt');
                });
          }
        },
        child: Icon(Icons.alternate_email),
      ),
    );
  }

  Widget _cameraButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.27,
      child: ElevatedButton(
        onPressed: () {
          _pickImage(ImageSource.camera);
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _portraitOrientation(Orientation orientation) {
    print(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 6,
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 15.0, 0, 15.0),
              width: MediaQuery.of(context).size.width * 0.60,
              height: MediaQuery.of(context).size.height * 0.60,
              child: _imageDisplay()),
        ),
        Expanded(
          flex: 1,
          child: Container(
            //margin: EdgeInsets.only(bottom: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _cropButton(orientation),
                _saveButton(),
                _convertButton(orientation),
              ],
            ),
          )
        ),
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _cameraButton(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(icon: Icon(Icons.menu),
                onPressed: () {
              Navigator.pushNamed(context, "/");
                }),
            IconButton(icon: Icon(Icons.camera),
                onPressed: () {
                  print(context);
                }),
            IconButton(icon: Icon(Icons.storage_rounded),
              onPressed: () {
              Navigator.pushNamed(context, "/email");
              },)
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Take Pictures'),
      ),
      body: OrientationBuilder(
        builder: (BuildContext orientationContext, orientation) {
          return orientation == Orientation.portrait ? _portraitOrientation(orientation) :
              _landscapeOrientation(orientation);
        },
      ),
    );
  }
}
