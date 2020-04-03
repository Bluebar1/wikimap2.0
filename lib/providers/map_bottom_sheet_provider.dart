import 'package:flutter/material.dart';
import 'package:wiki_map/models/article_model.dart';
import 'package:wiki_map/models/geosearch_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

/*
Created NB 4/2/2020
Provider class that will notify MapBottomSheet (map_bottom_sheet.dart)
When the list of Articles changes. 
Uses 'ChangeNotifier' and notifyListeners() to track state of class.
*/

class MapBottomSheetProvider with ChangeNotifier {
  List<Article> _currentArticles;
  List<Article> get currentArticles => _currentArticles;

  final String urlStart =
      "https://en.wikipedia.org/w/api.php?action=query&titles=";
  final String urlEnd = "&prop=pageimages&piprop=original&format=json";

  MapBottomSheetProvider(List<GeoSearch> geosearch) {
    _currentArticles = List<Article>();
    getAndSetArticles(geosearch);
  }

  void setCurrentArticles(List<Article> currentArticles) {
    _currentArticles = currentArticles;
    notifyListeners();
  }

  void addArticle(Article article) {
    _currentArticles.add(article);
    notifyListeners();
  }

  void getAndSetArticles(List<GeoSearch> geosearch) async {
    for (var geo in geosearch) {
      String dynamicUrl = Uri.encodeFull(urlStart + geo.title + urlEnd);
      var response = await http.get(dynamicUrl); //, headers: headers);
      var json = convert.jsonDecode(response.body);
      var jsonResults = json['query']['pages']['${geo.pageid}'];
      print('=-=-=-=-=-==-=-=-=-=-=-NEW ARTICLE BEING ADDED JSON: ' +
          jsonResults.toString());
      addArticle(Article.fromJson(jsonResults));
    }
  }
}
