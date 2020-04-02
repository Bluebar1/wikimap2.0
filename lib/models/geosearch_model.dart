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
        lat = parsedJson['lat'],
        lon = parsedJson['lon'],
        dist = parsedJson['dist'],
        primary = parsedJson['primary'];
}
