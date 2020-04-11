import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
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
  //stores list of image urls for horizontal swiping
  List<Article> _currentArticles;
  List<Article> get currentArticles => _currentArticles;
  //tracks if articles are done loading, is set to false when loading
  bool _isArticlesDoneLoading;
  bool get isArticlesDoneLoading => _isArticlesDoneLoading;
  //tracks if all the image pictures are done loading
  bool _isPagePicsDoneLoading;
  bool get isPagePicsDoneLoading => _isPagePicsDoneLoading;
  //stores names of files to be used to find url to files
  List<ImageFileName> _pictureFileNames;
  List<ImageFileName> get pictureFileNames => _pictureFileNames;
  //image urls to store vertical scrolling images
  List<String> _imageUrls;
  List<String> get imageUrls => _imageUrls;
  //list of summary of each wiki page in geosearch
  List<String> _summaries;
  List<String> get summaries => _summaries;
  //
  PhotoViewController _photoViewController;
  PhotoViewController get photoViewController => _photoViewController;
  //
  double _scale;
  double get scale => _scale;
  //
  int _indexOfImageTapped;
  int get indexOfImageTapped => _indexOfImageTapped;

  //url for finding each original image of the page
  final String urlStart =
      "https://en.wikipedia.org/w/api.php?action=query&titles=";
  final String urlEnd = "&prop=pageimages&piprop=original&format=json";
  //
  final List<GeoSearch> geosearch;
  final SwiperIndexProvider swiperIndexProvider;
  //
  MapBottomSheetProvider(this.geosearch, this.swiperIndexProvider) {
    print(
        'MAP SHEET PROVIDER CALLED, SWIPER INDEX= ${swiperIndexProvider.currentIndex}');
    _currentArticles = List<Article>(); //initialize empty lists to be filled
    _imageUrls = List<String>();
    _summaries = List<String>();
    _isArticlesDoneLoading = false;
    _isPagePicsDoneLoading = false;
    getAndSetArticles();
    getAndSetPagePics(); //geosearch);
    getAndSetSummaries();
  }

//=====================================================================================
  // SECTION FOR HANDLING DATA NEEDED FOR FULL SCREEN IMAGE VIEW
  //=====================================================================================

  void createPhotoViewController() {
    //_photoViewController = PhotoViewController();
    _photoViewController = PhotoViewController()
      ..outputStateStream.listen(listener);
  }

  void listener(PhotoViewControllerValue val) {
    _scale = val.scale;
    notifyListeners();
  }

  void setIndexOfImageTapped(int index) {
    _indexOfImageTapped = index;
  }

  //=====================================================================================
  // SECTION FOR RETRIEVING IMAGES TO BE DISPLAYED IN HORIZONTAL SWIPER
  //=====================================================================================

  /*
  Param: None
  Returns: Void
  Use: Called by the MapBottomSheetProvider constructor to make an async http get call
    for loaing the pictures to be displayed in the top horizontal swiper view
  */
  void getAndSetArticles() async {
    print(
        'GET AND SET ARTICLES CALLED WITH SWIPER: ${swiperIndexProvider.currentIndex}');
    String dynamicUrl = Uri.encodeFull(urlStart + buildArticleUrl() + urlEnd);
    var response = await http.get(dynamicUrl);
    var json = convert.jsonDecode(response.body);

    for (var geo in geosearch) {
      var jsonResult = json['query']['pages']['${geo.pageid}'];
      addArticle(Article.fromJson(jsonResult));
    }
  }

  /*
  Param: Article object (article_model.dart)
  Returns: void
  Use: Called by the getAndSetArticles method when iterating 
    through the json response. After notifying the listners,
    it checks if it is done loading. If it is done loading
    the setIsArticleDoneLoading changes the member variable to true
  */
  void addArticle(Article article) {
    _currentArticles.add(article);
    notifyListeners();
    if (_currentArticles.length == geosearch.length) {
      print(
          'ARTICLES DONE LOADING WITH CURRENT VALUE: ${_currentArticles.toString()}');
      setIsArticlesDoneLoading();
    }
  }

  //Notifies listners when articles are done loading
  void setIsArticlesDoneLoading() {
    _isArticlesDoneLoading = true;
    notifyListeners();
  }

  /*
  Param: List of Articles
  Returns: void
  Use: Sets member variable _currentArticles to a new list
    and notifies its listners
  */
  void setCurrentArticles(List<Article> currentArticles) {
    _currentArticles = currentArticles;
    notifyListeners();
  }

  //=====================================================================================
  // SECTION FOR RETRIEVING ALL IMAGES ON A SPECIFIC PAGE
  //=====================================================================================

  /*
  Param: None
  Returns: void
  Use: Uses the geosearch and swiperIndexProvider member variables to make an 
    async http get call to get the object that contains the FILE NAMES of all 
    the images on a specific wikipedia page. 
  */
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

  /*
  Params: List of dynamic objects
  Returns: void
  Use: Convert the json Response to a list of ImageFileName objects
    (image_file_name_model.dart) and passes that list to getUrlsFromFileNames()
  */
  setPictureFileNames(List<dynamic> jsonResults) {
    _pictureFileNames =
        jsonResults.map((e) => ImageFileName.fromJson(e)).toList();
    getUrlsFromFileNames();
  }

  /*
  Params: None
  Returns: void
  Use: Builds a url using the buildUrl() method and uses that URL to perform
    an async http.get call. The reponse is saved as a Map type and is iterated
    through on each level by multiple forEach function calls. When it is done iterating
    and saving the values it needs, it will call setImageUrls(templist) to set the member 
    to the newly created templist and notify its listeners
  */
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
          print('IMAGE URL PRINT OUT: ${value[0]['url']}');
          (value[0]['url'].contains('.svg') || value[0]['url'].contains('.tif'))
              ? print('NOT ADDED ${value[0]['url']}')
              : templist.add(value[0]['url']);
        }
      });
    });
    setImageUrls(templist);
  }

  //helper function for building a string for the article images
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

  //helper function for building a string for the page pics
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

  /*
  Param: List of strings 
  Returns: void
  Use: Called by getUrlsFromFileNames() function to set member variables
    and notify listeners relying on this data
  */
  void setImageUrls(List<String> urlList) {
    _imageUrls = urlList;
    setIsPagePicsDoneLoading();
    notifyListeners();
  }

  //Notifies listners when page pics are done loading
  void setIsPagePicsDoneLoading() {
    _isPagePicsDoneLoading = true;
    notifyListeners();
  }

  //=====================================================================================
  // SECTION FOR RETRIEVING ALL IMAGES ON A SPECIFIC PAGE
  //=====================================================================================

  //https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=

  void getAndSetSummaries() async {
    String _summaryStart =
        'https://en.wikipedia.org/w/api.php?format=json&action=query&prop=extracts&exintro&explaintext&redirects=1&titles=';
    String _summaryUrl = Uri.encodeFull(_summaryStart + buildArticleUrl());
    var response = await http.get(_summaryUrl);
    var json = convert.jsonDecode(response.body);
    for (var geo in geosearch) {
      var jsonResponse = json['query']['pages']['${geo.pageid}']['extract'];
      _summaries.add(jsonResponse);
      notifyListeners();
    }
  }
}
