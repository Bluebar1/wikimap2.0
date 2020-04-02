import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rubber/rubber.dart';
import 'package:wiki_map/models/geosearch_model.dart';
import 'package:wiki_map/screens/bottom_sheet.dart';
import 'package:wiki_map/services/geolocator_service.dart';
import 'package:wiki_map/services/marker_service.dart';
import 'package:wiki_map/services/bottomsheet_service.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final geoSearchProvider = Provider.of<Future<List<GeoSearch>>>(context);
    final markerService = MarkerService();
    //final geoService = GeoLocatorService();

    return FutureProvider(
        create: (context) => geoSearchProvider,
        child: Scaffold(
            body: (currentPosition != null)
                ? Stack(
                    children: <Widget>[
                      Consumer<List<GeoSearch>>(
                        builder: (_, results, __) {
                          var markers = (results != null)
                              ? markerService.getMarkers(results)
                              : List<Marker>();
                          return (results != null)
                              ? GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(currentPosition.latitude,
                                          currentPosition.longitude),
                                      zoom: 16.0),
                                  zoomGesturesEnabled: true,
                                  markers: Set<Marker>.of(markers),
                                )
                              : Center(child: CircularProgressIndicator());
                        },
                      ),
                      CustomBottomSheet()
                    ],
                  )
                : Center(child: CircularProgressIndicator())));
  }
}
