import 'dart:io';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/models/exif_model.dart';
import 'package:wiki_map/providers/geosearch_provider.dart';
import 'dart:convert' as convert;

import 'package:wiki_map/providers/swiper_index_provider.dart';
import 'package:wiki_map/screens/bottom_sheet.dart';

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
    var swiperIndexProvider = Provider.of<SwiperIndexProvider>(context);

    _startGeoSearch() {
      Position pos =
          Position(latitude: exif.gpsLatitude, longitude: exif.gpsLongitude);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
              value: GeoSearchProvider(pos, swiperIndexProvider, context),
              child: Consumer<GeoSearchProvider>(
                builder: (context, provider, child) {
                  return (provider.currentMarkers != null &&
                          provider.results != null)
                      ? CustomBottomSheet()
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ))));
    }

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
                ),
                FlatButton(
                  child: Text('GeoSearch from this Image',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.purpleAccent,
                  onPressed: () {
                    _startGeoSearch();
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
