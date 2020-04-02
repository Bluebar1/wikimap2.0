import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wiki_map/models/geosearch_model.dart';
import 'package:wiki_map/services/marker_service.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);
    final geoSearchProvider = Provider.of<Future<List<GeoSearch>>>(context);
    final markerService = MarkerService();

    return FutureProvider(
        create: (context) => geoSearchProvider,
        child: Scaffold(
            body: (currentPosition != null)
                ? Consumer<List<GeoSearch>>(
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
                  )
                : Center(child: CircularProgressIndicator())));
  }
}
