import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;

class ViewSavedPageProvider with ChangeNotifier {
  String _title;
  String _summary;
  String _imageUrl;
  dynamic _distance;
  dynamic _latitude;
  dynamic _longitude;
  int _pageId;

  String get title => _title;
  String get summary => _summary;
  String get imageUrl => _imageUrl;
  dynamic get distance => _distance;
  dynamic get latitude => _latitude;
  dynamic get longitude => _longitude;
  int get pageId => _pageId;

  String wikiSummaryUrl = Uri.encodeFull(
      "https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=");
  String wikiImageListUrl = Uri.encodeFull(
      "https://en.wikipedia.org/w/api.php?action=query&titles="); //Graffiti_000&ailimit=3")
  String noImageFound = Uri.encodeFull(
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bd/Apple_Garage.jpg/1280px-Apple_Garage.jpg"); //Graffiti_000&ailimit=3")
  //header for http requests
  Map<String, String> headers = {"Accept": "text/plain"};

  ViewSavedPageProvider(String title, int pageId) {
    print('VIEW SAVED PAGE PROVIDER CALLED');
    _title = null;
    _summary = null;
    _imageUrl = null;
    _distance = null;
    _latitude = null;
    _longitude = null;
    setPageId(pageId);
    setTitle(title);
    getAndSetSavedPageInfo(title, pageId);
  }

  getAndSetSavedPageInfo(String title, int pageId) async {
    return Future.wait([getWikiImageUrl(title, pageId)]).then((value) {
      print(
          "===============SET VALUE HERE ====================================");
      print(value);
      setImageUrl(value[0]);
    }).catchError((error) => _handleError(error));
  }

  _handleError(var err) {
    print("HANDLE VALUE CALLL RIGHT HERE--------------------------");
    print(err);
    print(err.runtimeType);
  }

  void setPageId(int pageId) {
    _pageId = pageId;
  }

  void setTitle(String title) {
    _title = title;
  }

  void setImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  Future<String> getWikiImageUrl(String title, int pageId) async {
    String _tempUrl;
    var imageResponse = await http.get(
        //http get request for the first image in the list
        wikiImageListUrl +
            Uri.encodeFull(title) +
            Uri.encodeFull('&prop=pageimages&piprop=original&format=json'),
        headers: headers);
    String jsonImageDataString =
        imageResponse.body.toString(); //convert the response to a string
    var _imgData =
        json.jsonDecode(jsonImageDataString); //convert to json variable
    if (_imgData['query']['pages'][pageId.toString()].length == 4) {
      //Uses pageIdList variable from MapProvider to check if that page has an image
      var _tempImgUrl = _imgData['query']['pages'][pageId.toString()]
              ['original'][
          'source']; //if it has an image ( .length == 4 ) then store link in a var
      String _full = _tempImgUrl
          .toString(); //substring conversions to check the ending will cause an error
      String _endString = _full.substring((_full.length) - 4, _full.length);
      if (_endString.contains('svg')) {
        _tempUrl =
            'https://www.solidbackgrounds.com/images/2560x1440/2560x1440-davys-grey-solid-color-background.jpg';
        //svg causes an error in the app, so a link to a blank background is added to the list instead

      } else {
        _tempUrl = _tempImgUrl;
      }
    } else {
      _tempUrl =
          'https://www.solidbackgrounds.com/images/2560x1440/2560x1440-davys-grey-solid-color-background.jpg';
      //if the contains no images ( .length is not 4 ) then add a blank background to the list
    }
    return _tempUrl;
  }
}
