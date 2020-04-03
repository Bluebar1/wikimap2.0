import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:wiki_map/models/geosearch_model.dart';

class GeoSearchService {
  Future<List<GeoSearch>> getPlaces(double lat, double lon) async {
    print('GEO SEARCH GET PLACED CALLED');
    String _wikiLocationUrlDynamic = Uri.encodeFull(
        "https://en.wikipedia.org/w/api.php?" +
            "action=query&list=geosearch&gscoord=" +
            lat.toString() +
            "|" +
            lon.toString() +
            "&gsradius=10000&gslimit=20&format=json");
    var response = await http.get(_wikiLocationUrlDynamic);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['query']['geosearch'] as List;
    return jsonResults
        .map((geosearch) => GeoSearch.fromJson(geosearch))
        .toList();
  }
}
