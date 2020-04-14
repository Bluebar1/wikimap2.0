import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelection extends StatefulWidget {
  _ImageSelection createState() => _ImageSelection();
}

class _ImageSelection extends State<ImageSelection> {
  String _path;
  bool isVideo = false;
  //String _retrieveDataError;

  void _showPhotoLibrary(BuildContext context) async {
    //Navigator.pop(context);
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _path = file.path;
    });
  }

  // Future<void> retrieveLostData() async {
  //   final LostDataResponse response = await ImagePicker.retrieveLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     if (response.type == RetrieveType.video) {
  //       isVideo = true;
  //       await _playVideo(response.file);
  //     } else {
  //       isVideo = false;
  //       setState(() {
  //         _imageFile = response.file;
  //       });
  //     }
  //   } else {
  //     _retrieveDataError = response.exception.code;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (_path != null)
                  ? Image.file(File(_path))
                  : SizedBox(height: 300, child: Text('No Photo Selected Yet')),
              FlatButton(
                child: Text('View Photo Library',
                    style: TextStyle(color: Colors.white)),
                color: Colors.green,
                onPressed: () {
                  isVideo = false;
                  _showPhotoLibrary(context);
                },
              ),
              FlatButton(
                child: Text('Print Image Specs',
                    style: TextStyle(color: Colors.white)),
                color: Colors.green,
                onPressed: () {
                  print(File(_path).toString());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
