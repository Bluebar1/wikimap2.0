import 'dart:io';
import 'dart:typed_data';

import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:wiki_map/models/exif_model.dart';

class ImageTestingProvider with ChangeNotifier {
  List<AssetPathEntity> _list;
  List<AssetPathEntity> get list => _list;

  List<AssetEntity> _entityList;
  List<AssetEntity> get entityList => _entityList;

  List<AssetEntity> _gpsEnts;
  List<AssetEntity> get gpsEnts => _gpsEnts;

  List<Position> _latlngList;
  List<Position> get latlngList => _latlngList;

  List<Uint8List> _thumbDataList;
  List<Uint8List> get thumbDataList => _thumbDataList;

  List<File> _imgFile;
  List<File> get imgFile => _imgFile;

  List<int> _albumGpsCounter;
  List<int> get albumGpsCounter => _albumGpsCounter;

  Exif _exif;
  Exif get exif => _exif;

  List<Exif> _exList;
  List<Exif> get exList => _exList;

  List<File> _gpsImagesList;
  List<File> get gpsImagesList => _gpsImagesList;

  bool _isDoneLoading;
  bool get isDoneLoading => _isDoneLoading;

  ImageTestingProvider() {
    _list = [];
    _entityList = [];
    _gpsImagesList = [];
    _exList = [];
    _gpsEnts = [];
    _latlngList = [];
    _thumbDataList = [];
    _albumGpsCounter = [];
    _imgFile = null;
    _exif = null;
    _isDoneLoading = false;
    _getAlbumList();
  }

  void _getAlbumList() async {
    _list = await PhotoManager.getAssetPathList();
    notifyListeners();
    _getAlbumGpsCountList().then((value) {
      _albumGpsCounter = value;
      notifyListeners();
    });
    //_albumGpsCounter = await Future.wait(_getAlbumGpsCountList());
    // int _albumIndex = 0;
    // //Future.wait(futures)
    // for (AssetPathEntity album in _list) {
    //   var temp = await album.assetList;
    //   for (AssetEntity ent in temp) {
    //     if (ent.latitude != 0.0) {
    //       _addOneToIndex(_albumIndex);
    //     }
    //   }
    //   _albumIndex++;
    //   //runAlbumGpsCount()
    // }
  }

  Future<List<int>> _getAlbumGpsCountList() async {
    int _albumIndex = 0;
    List<int> tempInt = List.filled(_list.length, 0);
    for (AssetPathEntity album in _list) {
      var temp = await album.assetList;
      for (AssetEntity ent in temp) {
        if (ent.latitude != 0.0) {
          tempInt[_albumIndex]++;
          //_addOneToIndex(_albumIndex);
        }
      }
      _albumIndex++;
      //runAlbumGpsCount()
    }
    return tempInt;
  }

  void _addOneToIndex(int index) {
    (_albumGpsCounter[index] != null)
        ? _albumGpsCounter[index]++
        : print('ADDED TO INDEX ERROR!!!!!');
  }

  //called when an album is selected
  void runPathsNew(int index) async {
    _latlngList = [];
    _gpsEnts = [];
    _entityList = [];
    _list.forEach((element) {
      print('${element.name}');
    });
    _entityList = await _list[index].assetList;
    for (AssetEntity ent in _entityList) {
      (ent.latitude != 0)
          ? addGpsEnt(
              ent, Position(latitude: ent.latitude, longitude: ent.longitude))
          : print('Entity ID: ${ent.id} did not have gps data');
    }
  }

  void addGpsEnt(AssetEntity element, Position tempLL) {
    print('add gps ent called');
    _addThumbnailData(element);
    _addLatLng(tempLL);
    _addGpsEnt(element);
  }

  void _addThumbnailData(AssetEntity element) async {
    _thumbDataList.add(await element.thumbDataWithSize(100, 100));
    notifyListeners();
  }

  void _addLatLng(Position ll) {
    _latlngList.add(ll);
    notifyListeners();
  }

  void _addGpsEnt(AssetEntity element) {
    _gpsEnts.add(element);
    notifyListeners();
  }
}

// void exifFromEntity(AssetEntity element) async {
//   LatLng tempLL;
//   print('EXIF FROM ENTITY CALLED');
//   //return await element.latlngAsync();
//   tempLL = await element.latlngAsync();
//   (tempLL != null) ? addGpsEnt(element, tempLL) : print('no gps found');

//   //return tempLL;
//   //print(tempLL.latitude);
// }

//void addElement(AssetEntity)

//=================================================

//   void _runPaths() async {
//     _list = await PhotoManager.getAssetPathList();
//     _list.forEach((element) {
//       print('${element.name}');
//     });
//     _runEntities();
//   }

//   void _runEntities() async {
//     print('RUN ENTITIES CALLED');
//     _entityList = await _list[6].assetList;
//     //_list.forEach((element) {print('${element.name}');});
//     _runFiles();
//   }

//   void _runFiles() {
//     print('RUN FILES CALLED');
//     _entityList.forEach((element) {
//       print('');
//       _runMoreFiles(element);
//     });
//     //now that I have the file paths, I need to check the exif of each
//     _checkAllExif();
//   }

//   void _checkAllExif() {
//     print('CHECK ALL EXIF HAS BEEN CALLED');
//     print('test');
//     print('${_imgFile[0].path}');
//     _imgFile.forEach((file) {
//       print('CHECK ALL EXIF FILE::: ${file.path}');
//       _checkExifOf(file);
//     });
//     //_isDoneLoading = true;
//   }

//   void _checkExifOf(File file) async {
//     print('CHECK EXIF OF HAS BEEN CALLED');
//     Exif tempEx;
//     Map<String, IfdTag> data;
//     try {
//       print('data about to be called');
//       data = await readExifFromFile(file);
//     } catch (err) {
//       print('exif catch error');
//       tempEx = null;
//     }
//     (data != null) ? tempEx = Exif.fromJson(data) : print('no exif found');
//     (tempEx.gpsLatitude != null) ? _exList.add(tempEx) : print('no lat found');

//     notifyListeners();
//   }

//   void _runMoreFiles(AssetEntity element) async {
//     print('RUN MORE FILES HAS BEEN CALLED');
//     File tempFile;
//     tempFile = await element.file;
//     (tempFile != null) ? _imgFile.add(tempFile) : print('MORE FILES ERROR');
//   }

//   void _runFile() async {
//     // File tempfile;
//     // tempfile = await
//     _imgFile[0] = await _entityList[0].file;
//     //_selectFilesWithGPS();
//     _runExif();
//   }

//   _runExif() async {
//     print('print exif called');
//     try {
//       Map<String, IfdTag> data = await readExifFromFile(_imgFile[0]);
//       _exif = Exif.fromJson(data);
//       notifyListeners();
//     } catch (err) {
//       print('EXIF ERROR');
//     }

//     print('EXIF PRINT OUT: $exif');
//   }
// }
