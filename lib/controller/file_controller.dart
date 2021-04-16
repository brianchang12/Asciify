import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';



class FileController {

  static FileController fileController;

  FileController();

  static FileController getInstance() {
    if (fileController == null) {
      return FileController();
    } else {
      return fileController;
    }
  }

  Future<File> getAsciiFile() async {
    print('Starting');
    FilePickerResult _pickedResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'jpg', 'png'],
    );
    print('finished picking');
    if (_pickedResult != null) {
      File file = File(_pickedResult.files.single.path);
      print('return files');
      return file;
    } else {
      return null;
    }
  }


}
