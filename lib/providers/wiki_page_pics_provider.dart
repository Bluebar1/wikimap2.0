import 'package:flutter/material.dart';
import 'package:wiki_map/models/image_file_name_model.dart';
import 'package:wiki_map/providers/geosearch_provider.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class WikiPagePicsProvider extends ChangeNotifier {
  List<ImageFileName> _pictureFileNames;
  List<ImageFileName> get pictureFileNames => _pictureFileNames;
  List<String> _imageUrls;
  List<String> get imageUrls => _imageUrls;
  bool _isDoneLoading;
  bool get isDoneLoading => _isDoneLoading;

  final GeoSearchProvider geosearchProvider;
  final SwiperIndexProvider swiperIndexProvider;

  WikiPagePicsProvider(this.geosearchProvider, this.swiperIndexProvider) {
    print('()()()()()()()()()()()()WIKI PAGE PICS PROVIDER CALLED');
    _pictureFileNames = null;
    _imageUrls = List<String>();
    _isDoneLoading = false;
    getPictureFileNames();
  }

  void getPictureFileNames() async {
    print('GET PICTURES HAS BEEN RUN');
    String _fileNameUrl = Uri.encodeFull(
        'https://en.wikipedia.org/w/api.php?action=query&titles=' +
            geosearchProvider.results[swiperIndexProvider.currentIndex].title +
            '&format=json&prop=images');

    var response = await http.get(_fileNameUrl);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['query']['pages'][
            '${geosearchProvider.results[swiperIndexProvider.currentIndex].pageid}']
        as List;
    setPictureFileNames(jsonResults);
  }

  void setPictureFileNames(List<dynamic> jsonResults) {
    _pictureFileNames =
        jsonResults.map((e) => ImageFileName.fromJson(e)).toList();
    getUrlsFromFileNames();
  }

  void getUrlsFromFileNames() async {
    List<String> templist = List<String>();
    String _wikiImagesUrl = Uri.encodeFull(
        'https://en.wikipedia.org/w/api.php?action=query&titles=' +
            buildUrl() +
            '&prop=imageinfo&iiprop=url&format=json');
    var response = await http.get(_wikiImagesUrl);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['query']['pages'] as Map;
    jsonResults.forEach((key, value) {
      value.forEach((key, value) {
        if (key == 'imageinfo') {
          templist.add(value[0]['url']);
          //addImageUrl(value[0]['url']);
        }
      });
    });
    setImageUrls(templist);
  }

  void setImageUrls(List<String> urlList) {
    print('============SET IMAGE URLS HAS BEEN CALLED');
    _imageUrls = urlList;
    notifyListeners();
  }

  String buildUrl() {
    List<String> tempstringlist = List<String>();
    for (var ifn in _pictureFileNames) {
      tempstringlist.add(ifn.title + '|');
    }
    var kontan = StringBuffer();
    tempstringlist.forEach((element) {
      kontan.write(element);
    });
    return kontan.toString().substring(0, kontan.length - 1);
  }
}
