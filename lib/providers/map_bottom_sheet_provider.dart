import 'package:flutter/material.dart';
import 'package:wiki_map/models/article_model.dart';
import 'package:wiki_map/models/geosearch_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:wiki_map/models/image_file_name_model.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';

/*
Created NB 4/2/2020
Provider class that will notify MapBottomSheet (map_bottom_sheet.dart)
When the list of Articles changes. 
Uses 'ChangeNotifier' and notifyListeners() to track state of class.
*/

class MapBottomSheetProvider with ChangeNotifier { 
  //
  List<Article>
      _currentArticles; //stores list of image urls for horizontal swiping
  List<Article> get currentArticles => _currentArticles;
  //
  bool
      _isArticlesDoneLoading; //tracks if articles are done loading, is set to false when loading
  bool get isArticlesDoneLoading => _isArticlesDoneLoading;
  //
  bool
      _isPagePicsDoneLoading; //tracks if all the image pictures are done loading
  bool get isPagePicsDoneLoading => _isPagePicsDoneLoading;
  //
  List<ImageFileName>
      _pictureFileNames; //stores names of files to be used to find url to files
  List<ImageFileName> get pictureFileNames => _pictureFileNames;
  //
  List<String> _imageUrls; //image urls to store vertical scrolling images
  List<String> get imageUrls => _imageUrls;

  final String urlStart = //url for finding each original image of the page
      "https://en.wikipedia.org/w/api.php?action=query&titles=";
  final String urlEnd = "&prop=pageimages&piprop=original&format=json";

  final List<GeoSearch>
      geosearch; //holds the list of GeoSeaerches passed to the constructor
  final SwiperIndexProvider
      swiperIndexProvider; //holds the state of swiperIndexProvder passed from the constructor

  MapBottomSheetProvider(this.geosearch, this.swiperIndexProvider) {
    print(
        'MAP SHEET PROVIDER CALLED, SWIPER INDEX= ${swiperIndexProvider.currentIndex}');
    _currentArticles = List<Article>(); //initialize empty lists to be filled
    _imageUrls = List<String>();
    _isArticlesDoneLoading = false;
    _isPagePicsDoneLoading = false;
    getAndSetArticles();
    getAndSetPagePics(); //geosearch);
  }

  void setCurrentArticles(List<Article> currentArticles) {
    _currentArticles = currentArticles;
    notifyListeners();
  }

  void addArticle(Article article) {
    _currentArticles.add(article);

    notifyListeners();
    if (_currentArticles.length == geosearch.length) {
      print(
          'ARTICLES DONE LOADING WITH CURRENT VALUE: ${_currentArticles.toString()}');
      // _currentArticles.forEach((element) {
      //   print('Title: ${element.title}');
      //   (element.original.source != null)
      //   ? print('${element.original.source}')
      //   : print('SOURCE IS NULL');
      // });
      
      setIsArticlesDoneLoading();
    }
  }

  void setIsArticlesDoneLoading() {
    _isArticlesDoneLoading = true;
    notifyListeners();
  }

  void setIsPagePicsDoneLoading() {
    _isPagePicsDoneLoading = true;
    notifyListeners();
  }

  void getAndSetArticles() async {
    print(
        'GET AND SET ARTICLES CALLED WITH SWIPER: ${swiperIndexProvider.currentIndex}');
    String dynamicUrl = Uri.encodeFull(urlStart + buildArticleUrl() + urlEnd);
    var response = await http.get(dynamicUrl);
    var json = convert.jsonDecode(response.body);
    //var jsonResults = json['query']['pages']; //as Map;
    //print('0000000000000000000000 $jsonResults');
    //print('TYPE::::::: ${jsonResults.runtimeType}');
    for (var geo in geosearch) {
      var jsonResult = json['query']['pages']['${geo.pageid}'];
      addArticle(Article.fromJson(jsonResult));
      // print('JSON RESULT::::::');
      // print(jsonResult);
    }

    // for (var geo in geosearch) {
    //   String dynamicUrl = Uri.encodeFull(urlStart + geo.title + urlEnd);
    //   var response = await http.get(dynamicUrl); //, headers: headers);
    //   var json = convert.jsonDecode(response.body);
    //   var jsonResults = json['query']['pages']['${geo.pageid}'];
    //   // print('=-=-=-=-=-==-=-=-=-=-=-NEW ARTICLE BEING ADDED JSON: ' +
    //   //     jsonResults.toString());
    //   addArticle(Article.fromJson(jsonResults));
    // }
  }

  void getAndSetPagePics() async {
    print(
        'GET AND SET PAGE PICS CALLED WITH SWIPER ${swiperIndexProvider.currentIndex}');
    String _fileNameUrl = Uri.encodeFull(
        'https://en.wikipedia.org/w/api.php?action=query&titles=' +
            geosearch[swiperIndexProvider.currentIndex].title +
            '&format=json&prop=images');
    var response = await http.get(_fileNameUrl);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['query']['pages']
            ['${geosearch[swiperIndexProvider.currentIndex].pageid}']['images']
        as List;
    setPictureFileNames(jsonResults);
  }

  setPictureFileNames(List<dynamic> jsonResults) {
    _pictureFileNames =
        jsonResults.map((e) => ImageFileName.fromJson(e)).toList();
    getUrlsFromFileNames();
  }

  void getUrlsFromFileNames() async {
    print(
        'GET URLS FROM FILE NAMES CALLED SWIPER: ${swiperIndexProvider.currentIndex}');
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
          print('i000000 IMAGE URL PRINT OUT: ${value[0]['url']}');
          (value[0]['url'].contains('.svg'))
          ? print('NOT ADDED ${value[0]['url']}')
          : templist.add(value[0]['url']);
          //addImageUrl(value[0]['url']);
        }
      });
    });
    setImageUrls(templist);
  }

  String buildArticleUrl() {
    List<String> tempstringlist = List<String>();
    for (var geo in geosearch) {
      tempstringlist.add(geo.title + '|');
    }
    var articleBuff = StringBuffer();
    tempstringlist.forEach((element) {
      articleBuff.write(element);
    });
    return articleBuff.toString().substring(0, articleBuff.length - 1);
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

  void setImageUrls(List<String> urlList) {
    _imageUrls = urlList;
    setIsPagePicsDoneLoading();
    notifyListeners();
  }
}
