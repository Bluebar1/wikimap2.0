import 'dart:io';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wiki_map/models/exif_model.dart';
import 'dart:convert' as convert;

class ImageSelection extends StatefulWidget {
  _ImageSelection createState() => _ImageSelection();
}

class _ImageSelection extends State<ImageSelection> {
  String _path;
  bool isVideo = false;
  Exif exif;
  //String _retrieveDataError;

  void _showPhotoLibrary(BuildContext context) async {
    //Navigator.pop(context);
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _path = file.path;
      _printExif();
    });
  }

  _printExif() async {
    print('print exif called');
    try {
      Map<String, IfdTag> data = await readExifFromFile(File(_path));
      setState(() {
        exif = Exif.fromJson(data);
      });
    } catch (err) {
      setState(() {
        exif = null;
      });
    }

    print('EXIF PRINT OUT: $exif');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (_path != null)
                    ? Image.file(File(_path))
                    : SizedBox(
                        height: 300, child: Text('No Photo Selected Yet')),
                (exif != null)
                    ? Center(
                        child:
                            Text('${exif.gpsLatitude} | ${exif.gpsLongitude}'))
                    : Center(
                        child: Text('No Exif Found'),
                      ),
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
                    _printExif();
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
