import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/providers/geosearch_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wiki_map/providers/swiper_index_provider.dart';

/*
Created NB 4/9/2020

Widget for displaying the Map, 
Uses data provided by GeoSearchProvider and SwiperIndexProvivder

When a point is pressed for 1 second, this widget will call the 
.getResults(position) function in the GeoSearchProvider class,
this will send a new APi geosearch request and load the data 
almost instantly.

TODO: (nb) display the active marker 
*/

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
      },
      onMapCreated: (controller) =>
          geoSearchProvider.createController(controller),

      onCameraMove: (position) =>
          geoSearchProvider.changeCurrentCameraPosition(position),
      // geoSearchProvider.controller.complete(controller),
    );
  }
}
