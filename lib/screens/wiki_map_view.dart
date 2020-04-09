import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/geosearch_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';

class WikiMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var geoSearchProvider = Provider.of<GeoSearchProvider>(context);
    var swiperIndexProvider = Provider.of<SwiperIndexProvider>(context);
    return GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(geoSearchProvider.startingPosition.latitude,
                geoSearchProvider.startingPosition.longitude),
            zoom: 16.0),
        zoomGesturesEnabled: true,
        markers: Set<Marker>.of(geoSearchProvider.currentMarkers.toList()),
        onLongPress: (position) {
          geoSearchProvider.getResults(Position(
              latitude: position.latitude, longitude: position.longitude));
          swiperIndexProvider.changeCurrentIndex(0);
        });
  }
}
