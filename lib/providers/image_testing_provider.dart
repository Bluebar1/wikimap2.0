import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageTestingProvider with ChangeNotifier {
  List<AssetPathEntity> _list = [];
  List<AssetPathEntity> get list => _list;

  ImageTestingProvider() {
    _runPaths();
  }

  void _runPaths() async {
    _list = await PhotoManager.getAssetPathList();
    notifyListeners();
  }
}
