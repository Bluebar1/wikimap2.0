import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wiki_map/models/geosearch_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:wiki_map/services/marker_service.dart';
/*
Created NB 4/5/2020
ChangeNotifierProvider class to run a wiki geosearch starting
at 'startingPosition', which is passed to this class on creation. 
*/

class GeoSearchProvider with ChangeNotifier {
  final Position startingPosition;
  final markerService = MarkerService();
  List<GeoSearch> _results; // = List<GeoSearch>();
  List<GeoSearch> get results => _results;

  List<Marker> _currentMarkers;
  List<Marker> get currentMarkers => _currentMarkers;

  GeoSearchProvider(this.startingPosition) {
    _results = null;
    _currentMarkers = null;
    getResults(startingPosition);
  }

  void getResults(Position startingPosition) async {
    print('=-=-=-GET RESULTS CALLED=-=-==-==-');
    String _wikiLocationUrlDynamic = Uri.encodeFull(
        "https://en.wikipedia.org/w/api.php?" +
            "action=query&list=geosearch&gscoord=" +
            startingPosition.latitude.toString() +
            "|" +
            startingPosition.longitude.toString() +
            "&gsradius=10000&gslimit=10&format=json");
    var response = await http.get(_wikiLocationUrlDynamic);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['query']['geosearch'] as List;
    print('JSON RESULTS::::::::::::: ${jsonResults.toString()}');
    print(jsonResults.toString());
    setResults(jsonResults);
  }

  void setResults(List<dynamic> jsonResults) {
    print('-=-=-=-SET RESULTS CALLED=-=-=-===- ${jsonResults.toString()}');
    print(jsonResults.runtimeType);

    _results =
        jsonResults.map((geosearch) => GeoSearch.fromJson(geosearch)).toList();
    print('====================================RESULTS RUNTIME TYPE : ' +
        _results.runtimeType.toString());
    setMarkers(_results);
    notifyListeners();
  }

  void setMarkers(List<GeoSearch> geosearch) {
    _currentMarkers = (geosearch != null)
        ? markerService.getMarkers(results)
        : List<Marker>();
    notifyListeners();
  }
}
