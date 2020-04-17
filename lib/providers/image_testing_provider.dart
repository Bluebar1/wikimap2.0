import 'dart:io';

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

  List<LatLng> _latlngList;
  List<LatLng> get latlngList => _latlngList;

  List<File> _imgFile;
  List<File> get imgFile => _imgFile;

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
    _imgFile = null;
    _exif = null;
    _isDoneLoading = false;
    getAlbumList();
    //runPathsNew(6);
  }

  void getAlbumList() async {
    _list = await PhotoManager.getAssetPathList();
    notifyListeners();
  }

  void runPathsNew(int index) async {
    _latlngList = [];
    _gpsEnts = [];
    _entityList = [];
    _list.forEach((element) {
      print('${element.name}');
    });
    _entityList = await _list[index].assetList;
    LatLng tempL;
    for (AssetEntity ent in _entityList) {
      tempL = await ent.latlngAsync();
      (tempL != null) ? addGpsEnt(ent, tempL) : print('no gps found');
    }
  }

  void addGpsEnt(AssetEntity element, LatLng tempLL) {
    print('add gps ent called');
    _addLatLng(tempLL);
    _addGpsEnt(element);
  }

  void _addLatLng(LatLng ll) {
    _latlngList.add(ll);
    notifyListeners();
  }

  void _addGpsEnt(AssetEntity element) {
    _gpsEnts.add(element);
    notifyListeners();
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

  void _runPaths() async {
    _list = await PhotoManager.getAssetPathList();
    _list.forEach((element) {
      print('${element.name}');
    });
    _runEntities();
  }

  void _runEntities() async {
    print('RUN ENTITIES CALLED');
    _entityList = await _list[6].assetList;
    //_list.forEach((element) {print('${element.name}');});
    _runFiles();
  }

  void _runFiles() {
    print('RUN FILES CALLED');
    _entityList.forEach((element) {
      print('');
      _runMoreFiles(element);
    });
    //now that I have the file paths, I need to check the exif of each
    _checkAllExif();
  }

  void _checkAllExif() {
    print('CHECK ALL EXIF HAS BEEN CALLED');
    print('test');
    print('${_imgFile[0].path}');
    _imgFile.forEach((file) {
      print('CHECK ALL EXIF FILE::: ${file.path}');
      _checkExifOf(file);
    });
    //_isDoneLoading = true;
  }

  void _checkExifOf(File file) async {
    print('CHECK EXIF OF HAS BEEN CALLED');
    Exif tempEx;
    Map<String, IfdTag> data;
    try {
      print('data about to be called');
      data = await readExifFromFile(file);
    } catch (err) {
      print('exif catch error');
      tempEx = null;
    }
    (data != null) ? tempEx = Exif.fromJson(data) : print('no exif found');
    (tempEx.gpsLatitude != null) ? _exList.add(tempEx) : print('no lat found');

    notifyListeners();
  }

  void _runMoreFiles(AssetEntity element) async {
    print('RUN MORE FILES HAS BEEN CALLED');
    File tempFile;
    tempFile = await element.file;
    (tempFile != null) ? _imgFile.add(tempFile) : print('MORE FILES ERROR');
  }

  void _runFile() async {
    // File tempfile;
    // tempfile = await
    _imgFile[0] = await _entityList[0].file;
    //_selectFilesWithGPS();
    _runExif();
  }

  _runExif() async {
    print('print exif called');
    try {
      Map<String, IfdTag> data = await readExifFromFile(_imgFile[0]);
      _exif = Exif.fromJson(data);
      notifyListeners();
    } catch (err) {
      print('EXIF ERROR');
    }

    print('EXIF PRINT OUT: $exif');
  }
}
