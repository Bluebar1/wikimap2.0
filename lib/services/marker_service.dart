import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wiki_map/models/geosearch_model.dart';

class MarkerService {
  List<Marker> getMarkers(List<GeoSearch> results) {
    print('GET MARKERS CALLED');
    var markers = List<Marker>();

    results.forEach((result) {
      Marker marker = Marker(
          markerId: MarkerId(result.hashCode.toString()),
          draggable: false,
          icon: BitmapDescriptor.defaultMarkerWithHue(100),
          infoWindow: InfoWindow(title: result.title),
          position: LatLng(result.lat, result.lon));

      markers.add(marker);
    });
    //print('MARKERS PRINTED OUT' + markers.toString());
    return markers;
  }
}
