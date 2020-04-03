/*
Created NB 4/2/2020
Data Structure to store information provided by
a wikipedia geosearch
*/

class GeoSearch {
  final int pageid;
  final int ns;
  final String title;
  final double lat;
  final double lon;
  final double dist;
  final String primary;

  GeoSearch(
      {this.pageid,
      this.ns,
      this.title,
      this.lat,
      this.lon,
      this.dist,
      this.primary});

  GeoSearch.fromJson(Map<dynamic, dynamic> parsedJson)
      : pageid = parsedJson['pageid'],
        ns = parsedJson['ns'],
        title = parsedJson['title'],
        lat = (parsedJson['lat'].runtimeType != int)
            ? parsedJson['lat']
            : parsedJson['lat'].toDouble(),
        lon = (parsedJson['lon'].runtimeType != int)
            ? parsedJson['lon']
            : parsedJson['lon'].toDouble(),
        dist = (parsedJson['dist'].runtimeType != int)
            ? parsedJson['dist']
            : parsedJson['dist'].toDouble(),
        primary = parsedJson['primary'];
}
