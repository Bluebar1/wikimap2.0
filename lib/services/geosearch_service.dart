import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:wiki_map/models/geosearch_model.dart';

class GeoSearchService {
  //final Map<String, String> headers = {"Accept": "text/plain"};

  //Future<List<GeoSearch>>
  Future<List<GeoSearch>> getPlaces(double lat, double lon) async {
    print('GEO SEARCH GET PLACED CALLED');
    String _wikiLocationUrlDynamic = Uri.encodeFull(
        "https://en.wikipedia.org/w/api.php?" +
            "action=query&list=geosearch&gscoord=" +
            lat.toString() +
            "|" +
            lon.toString() +
            "&gsradius=10000&gslimit=10&format=json");
    var response =
        await http.get(_wikiLocationUrlDynamic); //, headers: headers);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['query']['geosearch'] as List;
    print('JSON RESULTS::::::::::::::::' + jsonResults.toString());
    print(jsonResults[0].toString());
    return jsonResults
        .map((geosearch) => GeoSearch.fromJson(geosearch))
        .toList();
    //print(jsonResults);
    //return jsonResults.map((place) => GeoSearch.fromJson(place, icon)).toList();
  }
}
