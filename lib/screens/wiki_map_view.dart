import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/modules/animated_help.dart';
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
    return Scaffold(
      floatingActionButton: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black,
                    heroTag: "backbutton",
                    onPressed: () {
                      Navigator.of(context).pop();
                      print('back button pressed');
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 30,
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.black,
                    heroTag: "helpbutton",
                    onPressed: () {
                      showDialog(context: context, builder: (_) => Help());
                      print('help button pressed');
                    },
                    child: Icon(
                      Icons.help_outline,
                      size: 40,
                      color: Colors.black,
                    ),
                  ),
                )),
          )
        ],
      ),
      body: GoogleMap(
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
      ),
    );
  }
}
